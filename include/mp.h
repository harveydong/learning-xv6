// See MultiProcessor Specification Version 1.[14]
//MP Floating Pointer Structure added by harvey
struct mp {             // floating pointer
  uchar signature[4];           // "_MP_"
  uint  physaddr;               // phys addr of MP config table,MP configure table beginning address.
  uchar length;                 // 1
  uchar specrev;                // [14]
  uchar checksum;               // all bytes must add up to 0
  uchar type;                   // MP system config type, all 0: MP configure table present,else: the value indicates which default config is implemented by the system.
  uchar imcrp;	//bit7: IMCRP, when this bit is set, IMCR is present, PIC mode is implemneted.
  uchar reserved[3];		//MP FEATURE the last 4Byte.
};

//MP configure table header
struct mpconf {         // configuration table header
  uchar signature[4];           // "PCMP"
  ushort length;                // total table length
  uchar version;                // [14]
  uchar checksum;               // all bytes must add up to 0
  uchar product[20];            // product id
  uint  oemtable;               // OEM table pointer, a physical address pointer to an OEM-defined configuration table
  ushort oemlength;             // OEM table length
  ushort entry;                 // entry count,the number of entries in the variable porrion of the base table.
  uint  lapicaddr;              // address of local APIC
  ushort xlength;               // extended table length
  uchar xchecksum;              // extended table checksum
  uchar reserved;
};
//because the entry count,so type have: 0 for processor, 1 for bus, 2 for io apic, 3 for IO interrupt Assignment, 4 for Local Interrupt Assignment.
struct mpproc {         // processor table entry
  uchar type;                   // entry type (0)
  uchar apicid;                 // local APIC id
  uchar version;                // local APIC verison
  uchar flags;                  // CPU flags, bit0 for EN, bit 1 for BP.
    #define MPBOOT 0x02           // This proc is the bootstrap processor.
  uchar signature[4];           // CPU signature
  uint feature;                 // feature flags from CPUID instruction
  uchar reserved[8];
};

struct mpioapic {       // I/O APIC table entry
  uchar type;                   // entry type (2)
  uchar apicno;                 // I/O APIC id
  uchar version;                // I/O APIC version
  uchar flags;                  // I/O APIC flags
  uint  addr;                  // I/O APIC address
};

struct mpbus {
  uchar type;
  uchar busid;
  uchar bustype[6];
};

struct mpiointr{
 uchar type;
 uchar intr_type;
 ushort io_intr_flag;
 uchar s_bus_id;
 uchar s_bus_irq;
 uchar d_io_apic_id;
 uchar d_io_apic_intin;
 
 
};
// Table entry types
#define MPPROC    0x00  // One per processor
#define MPBUS     0x01  // One per bus
#define MPIOAPIC  0x02  // One per I/O APIC
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

//PAGEBREAK!
// Blank page.
