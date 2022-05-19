library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity datapath_mc is
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
        
        Instr_Reg: out std_logic_vector(31 downto 0);
                
        PC_sel: in std_logic;
        PC_LdEn: in std_logic;
                
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
end datapath_mc;


architecture Behavioral of datapath_mc is
    
    component ifstage is 
        Port (
            -- Component inputs
            PC_Immed: in std_logic_vector(31 downto 0);
            PC_sel: in std_logic;
            PC_LdEn: in std_logic;
            RST: in std_logic;
            CLK: in std_logic;
            -- Component outputs
            PC: out std_logic_vector(31 downto 0)
        );
    end component ifstage;
    
    component decstage is
        Port (
            -- Component inputs
            Instr: in std_logic_vector(31 downto 0);
            RF_WrEn: in std_logic;
            ALU_out: in std_logic_vector(31 downto 0);
            MEM_out: in std_logic_vector(31 downto 0);
            RF_WrData_sel: in std_logic;
            RF_B_sel: in std_logic;
            ImmExt: in std_logic_vector(1 downto 0);
            CLK: in std_logic;
            RST: in std_logic;
            
            -- Component outputs
            Immed: out std_logic_vector(31 downto 0);
            RF_A: out std_logic_vector(31 downto 0);
            RF_B: out std_logic_vector(31 downto 0)         
        );
    end component decstage;
    
    component exstage is
        Port (
            -- Component inputs 
            RF_A : in std_logic_vector(31 downto 0);
            RF_B : in std_logic_vector(31 downto 0);
            Immed: in std_logic_vector(31 downto 0);
            ALU_Bin_sel: in std_logic;
            ALU_func: in std_logic_vector(3 downto 0);
            
            -- Component outputs
            ALU_out: out std_logic_vector(31 downto 0);
            ALU_zero: out std_logic;
            ALU_ovf: out std_logic
        );
    end component exstage;
    
    component memstage is
        Port (
            -- Component inputs 
            ByteOp : in std_logic;
            Mem_WrEn : in std_logic;
            ALU_MEM_Addr: in std_logic_vector(31 downto 0);
            MEM_DataIn: in std_logic_vector(31 downto 0);
            MM_RdData: in std_logic_vector(31 downto 0);
    
            -- Component outputs
            MEM_DataOut: out std_logic_vector(31 downto 0);
            MM_WrEn: out std_logic;
            MM_Addr: out std_logic_vector(31 downto 0);
            MM_WrData: out std_logic_vector(31 downto 0)
        );
    end component memstage;
    
    
    component register_32 is
        Port (
            --Component inputs
            CLK: in std_logic;
            RST: in std_logic;
            WE: in std_logic;
            Datain: in std_logic_vector(31 downto 0);
            --Component outputs
            Dataout: out std_logic_vector(31 downto 0) 
        );
    end component register_32;
    
    signal tImmed, tRF_A, tRF_B, tALU_out, tMEM_out: std_logic_vector(31 downto 0);
    signal regRFa, regRfb, regInstr, regMem, regALUout: std_logic_vector(31 downto 0);
begin

    ifmodule:
        ifstage PORT MAP(
            PC_Immed => tImmed,
            PC_sel => PC_sel,
            PC_LdEn => PC_LdEn,
            RST => RST,
            CLK => CLK,
            PC => PC
        );
    
    decmodule:
        decstage PORT MAP(
            Instr => regInstr,
            RF_WrEn => RF_WrEn,
            ALU_out => tALU_out,
            MEM_out => regMem,
            RF_WrData_sel => RF_WrData_sel,
            RF_B_sel => RF_B_sel,
            ImmExt => ImmExt,
            CLK => CLK,
            RST => RST,
                        
            Immed => tImmed,
            RF_A => tRF_A,
            RF_B => tRF_B         
        );
    
    exmodule:
        exstage PORT MAP(
            RF_A => regRFa,
            RF_B => regRFb,
            Immed => tImmed,
            ALU_Bin_sel => ALU_Bin_sel,
            ALU_func => ALU_func,
            
            ALU_out => tALU_out,
            ALU_zero => ALU_zero,
            ALU_ovf => ALU_ovf
        );
        
    memmodule:
        memstage PORT MAP(
            ByteOp => ByteOp,
            Mem_WrEn => MEM_WrEn,
            ALU_MEM_Addr => regALUout,
            MEM_DataIn => tRF_B,
            MM_RdData => MM_RdData,
    
            MEM_DataOut => tMEM_out,
            MM_WrEn => MM_WrEn,
            MM_Addr => MM_Addr,
            MM_WrData => MM_WrData
        );
        
         
    reg_rf_A:
        register_32 PORT MAP(
            CLK => CLK,
            RST => RST,
            WE => RF_A_Reg_WrEn,
            Datain => tRF_A,
            Dataout => regRfa
        );
    
    reg_rf_B:
        register_32 PORT MAP(
            CLK => CLK,
            RST => RST,
            WE => RF_B_Reg_WrEn,
            Datain => tRF_B,
            Dataout => regRfb
        );
    
    reg_ALU_out: 
        register_32 PORT MAP(
            CLK => CLK,
            RST => RST,
            WE => ALU_out_reg_WrEn,
            Datain => tALU_out,
            Dataout => regAluout
        );
        
    reg_Instr:
        register_32 PORT MAP(
            CLK => CLK,
            RST => RST,
            WE => Instr_reg_WrEn,
            Datain => Instr,
            Dataout => regInstr       
        );  
          
    reg_Mem: 
        register_32 PORT MAP(
            CLK => CLK,
            RST => RST,
            WE => Mem_reg_WrEn,
            Datain => tMEM_out,
            Dataout => regMem
        );
        
    Instr_Reg <= regInstr;
        
end Behavioral;
