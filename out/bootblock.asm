
out/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	fa                   	cli    
    7c01:	31 c0                	xor    %eax,%eax
    7c03:	8e d8                	mov    %eax,%ds
    7c05:	8e c0                	mov    %eax,%es
    7c07:	8e d0                	mov    %eax,%ss
    7c09:	b8 00 7c 89 c4       	mov    $0xc4897c00,%eax

00007c0e <seta20.1>:
    7c0e:	e4 64                	in     $0x64,%al
    7c10:	a8 02                	test   $0x2,%al
    7c12:	75 fa                	jne    7c0e <seta20.1>
    7c14:	b0 d1                	mov    $0xd1,%al
    7c16:	e6 64                	out    %al,$0x64

00007c18 <seta20.2>:
    7c18:	e4 64                	in     $0x64,%al
    7c1a:	a8 02                	test   $0x2,%al
    7c1c:	75 fa                	jne    7c18 <seta20.2>
    7c1e:	b0 df                	mov    $0xdf,%al
    7c20:	e6 60                	out    %al,$0x60
    7c22:	88 16                	mov    %dl,(%esi)
    7c24:	65 7c b4             	gs jl  7bdb <start-0x25>
    7c27:	42                   	inc    %edx
    7c28:	8a 16                	mov    (%esi),%dl
    7c2a:	65 7c be             	gs jl  7beb <start-0x15>
    7c2d:	ca 7c cd             	lret   $0xcd7c
    7c30:	13 72 57             	adc    0x57(%edx),%esi
    7c33:	0f 01 16             	lgdtl  (%esi)
    7c36:	b4 7c                	mov    $0x7c,%ah
    7c38:	0f 20 c0             	mov    %cr0,%eax
    7c3b:	66 83 c8 01          	or     $0x1,%ax
    7c3f:	0f 22 c0             	mov    %eax,%cr0
    7c42:	ea                   	.byte 0xea
    7c43:	47                   	inc    %edi
    7c44:	7c 08                	jl     7c4e <start32+0x7>
	...

00007c47 <start32>:
    7c47:	66 b8 10 00          	mov    $0x10,%ax
    7c4b:	8e d8                	mov    %eax,%ds
    7c4d:	8e c0                	mov    %eax,%es
    7c4f:	8e d0                	mov    %eax,%ss
    7c51:	66 b8 00 00          	mov    $0x0,%ax
    7c55:	8e e0                	mov    %eax,%fs
    7c57:	8e e8                	mov    %eax,%gs
    7c59:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c5e:	e8 77 00 00 00       	call   7cda <bootmain>

00007c63 <spin>:
    7c63:	eb fe                	jmp    7c63 <spin>

00007c65 <DriveNumber>:
	...

00007c66 <msg_ReadFail>:
    7c66:	46                   	inc    %esi
    7c67:	61                   	popa   
    7c68:	69 6c 65 64 20 74 6f 	imul   $0x206f7420,0x64(%ebp,%eiz,2),%ebp
    7c6f:	20 
    7c70:	72 65                	jb     7cd7 <ST3_DAP+0xd>
    7c72:	61                   	popa   
    7c73:	64 20 64 72 69       	and    %ah,%fs:0x69(%edx,%esi,2)
    7c78:	76 65                	jbe    7cdf <bootmain+0x5>
    7c7a:	2e                   	cs
	...

00007c7c <print_string_16>:
    7c7c:	60                   	pusha  
    7c7d:	b4 0e                	mov    $0xe,%ah

00007c7f <.repeat>:
    7c7f:	ac                   	lods   %ds:(%esi),%al
    7c80:	3c 00                	cmp    $0x0,%al
    7c82:	74 04                	je     7c88 <.done>
    7c84:	cd 10                	int    $0x10
    7c86:	eb f7                	jmp    7c7f <.repeat>

00007c88 <.done>:
    7c88:	61                   	popa   
    7c89:	c3                   	ret    

00007c8a <read_fail>:
    7c8a:	66 8b 35 66 7c 00 00 	mov    0x7c66,%si
    7c91:	e8 e6 ff ff ff       	call   7c7c <print_string_16>
    7c96:	eb 00                	jmp    7c98 <halt>

00007c98 <halt>:
    7c98:	f4                   	hlt    
    7c99:	eb fd                	jmp    7c98 <halt>
    7c9b:	90                   	nop

00007c9c <gdt>:
	...
    7ca4:	ff                   	(bad)  
    7ca5:	ff 00                	incl   (%eax)
    7ca7:	00 00                	add    %al,(%eax)
    7ca9:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7cb0:	00                   	.byte 0x0
    7cb1:	92                   	xchg   %eax,%edx
    7cb2:	cf                   	iret   
	...

00007cb4 <gdtdesc>:
    7cb4:	17                   	pop    %ss
    7cb5:	00                   	.byte 0x0
    7cb6:	9c                   	pushf  
    7cb7:	7c 00                	jl     7cb9 <gdtdesc+0x5>
	...

00007cba <ST2_DAP>:
    7cba:	10 00                	adc    %al,(%eax)
    7cbc:	10 00                	adc    %al,(%eax)
    7cbe:	00 80 00 00 01 00    	add    %al,0x10000(%eax)
    7cc4:	00 00                	add    %al,(%eax)
    7cc6:	00 00                	add    %al,(%eax)
	...

00007cca <ST3_DAP>:
    7cca:	10 00                	adc    %al,(%eax)
    7ccc:	64 00 00             	add    %al,%fs:(%eax)
    7ccf:	00 00                	add    %al,(%eax)
    7cd1:	10 01                	adc    %al,(%ecx)
    7cd3:	00 00                	add    %al,(%eax)
    7cd5:	00 00                	add    %al,(%eax)
    7cd7:	00 00                	add    %al,(%eax)
	...

00007cda <bootmain>:
    7cda:	55                   	push   %ebp
    7cdb:	ba 00 00 01 00       	mov    $0x10000,%edx
    7ce0:	89 e5                	mov    %esp,%ebp
    7ce2:	57                   	push   %edi
    7ce3:	56                   	push   %esi
    7ce4:	53                   	push   %ebx
    7ce5:	31 f6                	xor    %esi,%esi
    7ce7:	83 ec 1c             	sub    $0x1c,%esp
    7cea:	c6 05 00 80 0b 00 61 	movb   $0x61,0xb8000
    7cf1:	c6 05 02 80 0b 00 61 	movb   $0x61,0xb8002
    7cf8:	c6 05 04 80 0b 00 61 	movb   $0x61,0xb8004
    7cff:	c6 05 06 80 0b 00 61 	movb   $0x61,0xb8006
    7d06:	c6 05 08 80 0b 00 61 	movb   $0x61,0xb8008
    7d0d:	81 3a 02 b0 ad 1b    	cmpl   $0x1badb002,(%edx)
    7d13:	75 10                	jne    7d25 <bootmain+0x4b>
    7d15:	8b 42 04             	mov    0x4(%edx),%eax
    7d18:	8b 4a 08             	mov    0x8(%edx),%ecx
    7d1b:	01 c1                	add    %eax,%ecx
    7d1d:	81 f9 fe 4f 52 e4    	cmp    $0xe4524ffe,%ecx
    7d23:	74 0e                	je     7d33 <bootmain+0x59>
    7d25:	46                   	inc    %esi
    7d26:	83 c2 04             	add    $0x4,%edx
    7d29:	81 fe 00 08 00 00    	cmp    $0x800,%esi
    7d2f:	75 dc                	jne    7d0d <bootmain+0x33>
    7d31:	eb 58                	jmp    7d8b <bootmain+0xb1>
    7d33:	a9 00 00 01 00       	test   $0x10000,%eax
    7d38:	74 51                	je     7d8b <bootmain+0xb1>
    7d3a:	8b 7a 10             	mov    0x10(%edx),%edi
    7d3d:	8b 5a 0c             	mov    0xc(%edx),%ebx
    7d40:	39 df                	cmp    %ebx,%edi
    7d42:	77 47                	ja     7d8b <bootmain+0xb1>
    7d44:	8b 42 14             	mov    0x14(%edx),%eax
    7d47:	39 c7                	cmp    %eax,%edi
    7d49:	77 40                	ja     7d8b <bootmain+0xb1>
    7d4b:	29 f8                	sub    %edi,%eax
    7d4d:	89 c1                	mov    %eax,%ecx
    7d4f:	c1 e9 02             	shr    $0x2,%ecx
    7d52:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    7d55:	89 f9                	mov    %edi,%ecx
    7d57:	29 d9                	sub    %ebx,%ecx
    7d59:	8d b4 b1 00 00 01 00 	lea    0x10000(%ecx,%esi,4),%esi
    7d60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    7d63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    7d65:	89 c1                	mov    %eax,%ecx
    7d67:	83 e1 03             	and    $0x3,%ecx
    7d6a:	74 02                	je     7d6e <bootmain+0x94>
    7d6c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
    7d6e:	8b 4a 18             	mov    0x18(%edx),%ecx
    7d71:	8b 7a 14             	mov    0x14(%edx),%edi
    7d74:	39 f9                	cmp    %edi,%ecx
    7d76:	76 07                	jbe    7d7f <bootmain+0xa5>
    7d78:	29 f9                	sub    %edi,%ecx
    7d7a:	31 c0                	xor    %eax,%eax
    7d7c:	fc                   	cld    
    7d7d:	f3 aa                	rep stos %al,%es:(%edi)
    7d7f:	8b 42 1c             	mov    0x1c(%edx),%eax
    7d82:	83 c4 1c             	add    $0x1c,%esp
    7d85:	5b                   	pop    %ebx
    7d86:	5e                   	pop    %esi
    7d87:	5f                   	pop    %edi
    7d88:	5d                   	pop    %ebp
    7d89:	ff e0                	jmp    *%eax
    7d8b:	83 c4 1c             	add    $0x1c,%esp
    7d8e:	5b                   	pop    %ebx
    7d8f:	5e                   	pop    %esi
    7d90:	5f                   	pop    %edi
    7d91:	5d                   	pop    %ebp
    7d92:	c3                   	ret    
