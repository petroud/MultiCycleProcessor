library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity proc_mc is
    Port( 
          CLK : in STD_LOGIC;
          RST : in STD_LOGIC
        );
end proc_mc;

architecture Behavioral of proc_mc is


    component RAM is
        port (
            clk : in std_logic;
            inst_addr : in std_logic_vector(10 downto 0);
            inst_dout : out std_logic_vector(31 downto 0);
            data_we : in std_logic;
            data_addr : in std_logic_vector(10 downto 0);
            data_din : in std_logic_vector(31 downto 0);
            data_dout : out std_logic_vector(31 downto 0)
        );
    end component RAM;
    
    component control_mc is
         Port (
            CLK: in std_logic;
            RST: in std_logic;
            -- Entity inputs
            Instr: in std_logic_vector(31 downto 0);
            ALU_zero: in std_logic;
            
            -- Entity outputs
            PC_sel: out std_logic;
            PC_LdEn: out std_logic;
            ALU_func: out std_logic_vector(3 downto 0);
            ALU_bin_sel: out std_logic;
            RF_WrEn: out std_logic;
            RF_B_sel: out std_logic;
            RF_WrData_sel: out std_logic;
            ImmExt: out std_logic_vector(1 downto 0);
            Mem_WrEn: out std_logic;
            ByteOp: out std_logic;  
             
            -- Datapath Registers Control Signals
            Instr_Reg_WrEn: out std_logic;
            RF_A_Reg_WrEn: out std_logic;
            RF_B_Reg_WrEn: out std_logic;
            ALU_out_Reg_WrEn: out std_logic;
            MEM_Reg_WrEn: out std_logic                     
        );
    end component control_mc;
    
    component datapath_mc is
        Port (
            --Entity inputs
            CLK: in std_logic;
            RST: in std_logic;
            ImmExt: in std_logic_vector(1 downto 0);
            RF_WrEn: in std_logic;
            RF_B_sel: in std_logic;
            RF_WrData_sel: in std_logic;
            ALU_Bin_sel: in std_logic;
            ALU_func: in std_logic_vector(3 downto 0);
            ByteOp: in std_logic;
            
            MEM_WrEn: in std_logic; 
            MM_RdData: in std_logic_vector(31 downto 0);
            Instr: in std_logic_vector(31 downto 0);
                    
            PC_sel: in std_logic;
            PC_LdEn: in std_logic;
            
            Instr_Reg: out std_logic_vector(31 downto 0);
            
            --Entity outputs
            ALU_zero: out std_logic;
            ALU_ovf: out std_logic;
            PC: out std_logic_vector(31 downto 0);
            MM_Addr: out std_logic_vector(31 downto 0);
            MM_WrData: out std_logic_vector(31 downto 0);
            MM_WrEn: out std_logic;
            
             --Register ports
            Instr_Reg_WrEn: in std_logic;
            RF_A_Reg_WrEn: in std_logic;
            RF_B_Reg_WrEn: in std_logic;
            ALU_out_Reg_WrEn: in std_logic;
            Mem_Reg_WrEn: in std_logic                   
        );
    end component datapath_mc;
    
signal tPC, tData_Addr: std_logic_vector(10 downto 0);
signal pc32, addr32: std_logic_vector(31 downto 0);
signal tInstr, tMM_WrData, tMM_RdData: std_logic_vector(31 downto 0);
signal tMM_WrEn, tRF_WrEn, tRF_B_sel, tALU_Bin_sel, tByteOp, tWrData_sel, tMEM_WrEn: std_logic;
signal tRF_WrData_sel, tPC_LdEn, tPC_sel, tALU_zero, tALU_ovf: std_logic;
signal tImmExt: std_logic_vector(1 downto 0);
signal tALU_func: std_logic_vector(3 downto 0);   
signal tRF_A_WE, tRF_B_WE, tALU_WE, tMEM_WE, tINSTR_wE: std_logic; 
signal tInstrReg: std_logic_vector(31 downto 0);
signal tImmedReg: std_logic_vector(31 downto 0);

begin

    tPC <= pc32(12 downto 2);
    tData_Addr <= addr32(10 downto 0);

    ramModule: RAM PORT MAP(
        clk => CLK,
        inst_addr => tPC, 
        inst_dout => tInstr,
        data_we => tMM_WrEn,
        data_addr => tData_Addr,
        data_din => tMM_WrData,
        data_dout => tMM_RdData
    );
    
    datapathModule: datapath_mc PORT MAP(
        CLK => CLK,
        RST => RST,
        ImmExt => tImmExt,
        RF_WrEn => tRF_WrEn,
        RF_B_sel => tRF_B_sel,
        RF_WrData_sel => tRF_WrData_sel,
        ALU_Bin_sel => tALU_Bin_sel,
        ALU_func => tALU_func,
        ByteOp => tByteOp, 
        MEM_WrEn => tMEM_WrEn,
        MM_RdData => tMM_RdData,
        Instr => tInstr, 
        PC_sel => tPC_sel,
        PC_LdEn => tPC_LdEn,
        ALU_zero => tALU_zero,
        ALU_ovf => tALU_ovf,
        PC => pc32,
        MM_Addr => addr32, 
        MM_WrData => tMM_WrData,
        MM_WrEn => tMM_WrEn,
        
        Instr_Reg => tInstrReg,
        
        Instr_Reg_WrEn => tINSTR_WE, 
        RF_A_Reg_WrEn => tRF_A_WE,
        RF_B_Reg_WrEn => tRF_B_WE,
        ALU_out_Reg_WrEn => tALU_WE,
        Mem_Reg_WrEn => tMEM_WE 
                
    );
    
    controlModule: control_mc PORT MAP(
        CLK => CLK,
        RST => RST,
        Instr => tInstrReg,
        ALU_zero => tALU_zero,        
        PC_sel => tPC_sel,
        PC_LdEn => tPC_LdEn,
        ALU_func => tALU_func,
        ALU_bin_sel => tALU_bin_sel,
        RF_WrEn => tRF_WrEn,
        RF_B_sel => tRF_B_sel,
        RF_WrData_sel => tRF_WrData_sel,
        ImmExt => tImmExt,
        Mem_WrEn => tMEM_WrEn,
        ByteOp => tByteOp,
        
        Instr_Reg_WrEn => tINSTR_WE, 
        RF_A_Reg_WrEn => tRF_A_WE,
        RF_B_Reg_WrEn => tRF_B_WE,
        ALU_out_Reg_WrEn => tALU_WE,
        Mem_Reg_WrEn => tMEM_WE 
        
    );


end Behavioral;
