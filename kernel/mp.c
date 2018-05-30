// Multiprocessor support
// Search memory for MP description structures.
// http://developer.intel.com/design/pentium/datashts/24201606.pdf

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mp.h"
#include "x86.h"
#include "mmu.h"
#include "proc.h"

struct cpu cpus[NCPU];
static struct cpu *bcpu;
int ismp;
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  return sum;
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  uchar *e, *p, *addr;
  struct mp *tmp;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0){
		tmp = (struct mp*)p;
		cprintf("mp floating pointer:\n");
		cprintf("mp sig:%x%x%x%x\n",tmp->signature[0],tmp->signature[1],tmp->signature[2],tmp->signature[3]);
		cprintf("mp phy addr:0x%x\n",tmp->physaddr);
		cprintf("mp length:0x%x\n",tmp->length);
		cprintf("mp spec rev:0x%x\n",tmp->specrev);
		cprintf("mp type:0x%x\n",tmp->type);
		cprintf("mp imcrp:0x%x\n",tmp->imcrp);
		
		
      return (struct mp*)p;
    }
  return 0;
}

// Search for the MP Floating Pointer Structure, which according to the
// spec is in one of the following three locations:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM address space between 0F0000h and 0FFFFFh.
static struct mp*
mpsearch(void)
{
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
	  cprintf("ebda addr here\n");
    if((mp = mpsearch1(p, 1024))){
		cprintf("look for floating pointer from ebda:%p",mp);
      return mp;
    }
  } else {
	
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    cprintf("mpserch from system base memory:%p\n",p);
    if((mp = mpsearch1(p-1024, 1024))){
		cprintf("look for floating pointer from system base memory:%p",mp);
      return mp;
    }
  }
  cprintf("mpserch from 0xf0000--0x10000\n");
  return mpsearch1(0xF0000, 0x10000);
}

// Search for an MP configuration table.  For now,
// don't accept the default configurations (physaddr == 0).
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) p2v((uintp) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
    return 0;
  *pmp = mp;
  return conf;
}

void
mpinit(void)
{
  uchar *p, *e;
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;
  struct mpbus *mpbus;
  struct mpiointr  *iointr;
  
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = IO2V((uintp)conf->lapicaddr);
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cprintf("mpinit ncpu=%d apicid=%d,local apic version:0x%x,cpu flags:0x%x,feature:0x%x\n", ncpu, proc->apicid,proc->version,proc->flags,proc->feature);
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
      cpus[ncpu].apicid = proc->apicid;
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
      p += sizeof(struct mpioapic);
      cprintf("mp config io apic:\n");
      cprintf("ioapic: id:0x%x, version:0x%x,flags:0x%x,mmio:0x%p\n",ioapic->apicno,ioapic->version,ioapic->flags,ioapic->addr);
      continue;
    case MPBUS:
		mpbus = (struct mpbus *)p;
		cprintf("mp config bus:\n");
		cprintf("bus id:0x%x\n",mpbus->busid);
		cprintf("bus type:%s\n",mpbus->bustype);
		
		p += sizeof(struct mpbus);
		continue;
    case MPIOINTR:
		iointr = (struct mpiointr *)p;
		p+=8;
		cprintf("mp io intr:\n");
		cprintf("intr_type:0x%x,io_intr_flag:0x%x,s_id:0x%x,s_irq:0x%x,d_ioapic_id:0x%x,d_ioapic_intin:0x%x\n",iointr->intr_type,iointr->io_intr_flag,iointr->s_bus_id,iointr->s_bus_irq,iointr->d_io_apic_id,iointr->d_io_apic_intin);
    case MPLINTR:
     
      p += 8;
      continue;
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
    // it would run on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
