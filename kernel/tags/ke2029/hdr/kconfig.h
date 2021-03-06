/*
    KConfig.h  
    
    DLASortByDriveNo
        0 : Drive Letter Assignement ike MSDOS
        1 : DLA - first drive completely first, then to next drive    

    InitDiskShowDriveAssignment
        0   : don't show what drive/partition assigned to what drive letter
        1   : show info 
        
    SkipConfigSeconds:
        < 0 : not possible to skip config.sys
        = 0 : only possible if already pressed before, no message
        > 0 : wait so long for F5/F8
*/
typedef struct _KernelConfig {
  char CONFIG[6];               /* "CONFIG" */
  unsigned short ConfigSize;

  unsigned char DLASortByDriveNo;
  unsigned char InitDiskShowDriveAssignment;
  signed char SkipConfigSeconds;
  unsigned char ForceLBA;
  unsigned char GlobalEnableLBAsupport; /* = 0 --> disable LBA support */
} KernelConfig;
