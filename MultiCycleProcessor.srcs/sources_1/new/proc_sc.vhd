library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity proc_sc is
    Port(
        CLK: in std_logic;
        RST: in std_logic
    );
end proc_sc;

architecture Behavioral of proc_sc is


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
    
    component control is
         Port (
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
            ByteOp: out std_logic        
        );
    end component control;
    
    component datapath is
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
            
            --Entity outputs
            ALU_zero: out std_logic;
            ALU_ovf: out std_logic;
            PC: out std_logic_vector(31 downto 0);
            MM_Addr: out std_logic_vector(31 downto 0);
            MM_WrData: out std_logic_vector(31 downto 0);
            MM_WrEn: out std_logic        
        );
    end component datapath;    

signal tPC, tData_Addr: std_logic_vector(10 downto 0);
signal pc32, addr32: std_logic_vector(31 downto 0);
signal tInstr, tMM_WrData, tMM_RdData: std_logic_vector(31 downto 0);
signal tMM_WrEn, tRF_WrEn, tRF_B_sel, tALU_Bin_sel, tByteOp, tWrData_sel, tMEM_WrEn: std_logic;
signal tRF_WrData_sel, tPC_LdEn, tPC_sel, tALU_zero, tALU_ovf: std_logic;
signal tImmExt: std_logic_vector(1 downto 0);
signal tALU_func: std_logic_vector(3 downto 0);

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
    
    datapathModule: datapath PORT MAP(
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
        MM_WrEn => tMM_WrEn
    );
    
    controlModule: control PORT MAP(
        Instr => tInstr,
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
        ByteOp => tByteOp
    );
    
   
    
    
    

    


end Behavioral;
