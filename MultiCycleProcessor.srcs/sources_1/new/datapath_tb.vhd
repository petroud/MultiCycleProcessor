library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity datapath_tb is
end datapath_tb;

architecture Behavioral of datapath_tb is
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
    
    end component;

signal CLK,RST,RF_WrEn,RF_B_sel,RF_WrData_sel,ALU_Bin_sel,ByteOp,MEM_WrEn,PC_sel,PC_LdEn,ALU_zero,ALU_ovf,MM_WrEn: std_logic;
signal MM_RdData, Instr, PC, MM_Addr, MM_WrData: std_logic_vector(31 downto 0);
signal ALU_func: std_logic_vector(3 downto 0);
signal ImmExt: std_logic_vector(1 downto 0);
signal inner_termin: std_logic;

begin
    uut: datapath PORT MAP(
        --Entity inputs
        CLK => CLK,
        RST => RST,
        ImmExt => ImmExt,
        RF_WrEn => RF_WrEn,
        RF_B_sel => RF_B_sel,
        RF_WrData_sel => RF_WrData_sel,
        ALU_Bin_sel => ALU_Bin_sel,
        ALU_func => ALU_func,
        ByteOp => ByteOp,
        MEM_WrEn => MEM_WrEn,
        MM_RdData => MM_RdData,
        Instr => Instr,
        PC_sel => PC_sel,
        PC_LdEn => PC_LdEn,
  
        ALU_zero => ALU_zero,
        ALU_ovf => ALU_ovf,
        PC => PC,
        MM_Addr => MM_Addr,
        MM_WrData => MM_WrData,
        MM_WrEn => MM_WrEn       
    );
    
    
    simProcess: process begin
        RST<='1'; 
        wait for 200ns;
        RST<='0';
        
        ImmExt <= "00";
        RF_WrEn <= '1';
        RF_B_sel <= '1';
        RF_WrData_sel <= '1';
        ALU_Bin_sel <= '1';
        ALU_func <= "0000";
        ByteOp <= '0';
        MEM_WrEn <= '0';
        MM_RdData <= x"0000abcd";
        Instr <= "110000" & "00000" & "00101" & "0000000000001000";
        PC_sel <= '0';
        PC_LdEn <= '1';
        wait for 100ns;
        
        
        ImmExt <= "00";
        RF_WrEn <= '1';
        RF_B_sel <= '0';
        RF_WrData_sel <= '1';
        ALU_Bin_sel <= '0';
        ALU_func <= "0101";
        ByteOp <= '0';
        MEM_WrEn <= '0';
        MM_RdData <= x"0000abcd";
        Instr <= "100000" & "01010" & "00100" & "10000" & "00000" & "110101";
        PC_sel <= '0';
        PC_LdEn <= '1';
        wait for 100ns;
        
        ImmExt <= "01";
        RF_WrEn <= '1';
        RF_B_sel <= '1';
        RF_WrData_sel <= '1';
        ALU_Bin_sel <= '1';
        ALU_func <= "0001";
        ByteOp <= '0';
        MEM_WrEn <= '0';
        MM_RdData <= x"0000abcd";
        Instr <= "000001" & "00101" & "00101" & "0000000000001000";
        PC_sel <= '1';
        PC_LdEn <= '1';
        wait for 100ns;               
        
        wait;
    end process;
    
    
    --Process for generating clock signal 
    clkProcess: process begin
        --Vary the clock signal for low to high every 30ns 
        --Period = 100ns
        CLK <= '0';
        wait for 50ns;
        CLK <= '1';
        wait for 50ns;
        
        --The terminationg flag will be HIGH after a certain time 
        --The clock is generated for this amount of time 
        inner_termin<='1' after 3000ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;




end Behavioral;
