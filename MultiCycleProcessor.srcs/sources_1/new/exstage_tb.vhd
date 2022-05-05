library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity exstage_tb is
end exstage_tb;

architecture Behavioral of exstage_tb is
    
    component exstage is
        Port (
            RF_A : in std_logic_vector(31 downto 0);
            RF_B : in std_logic_vector(31 downto 0);
            Immed: in std_logic_vector(31 downto 0);
            ALU_Bin_sel: in std_logic;
            ALU_func: in std_logic_vector(3 downto 0);
            ALU_out: out std_logic_vector(31 downto 0);
            ALU_zero: out std_logic;
            ALU_ovf: out std_logic
        );
    end component;

signal RF_A,RF_B,Immed,ALU_out : std_logic_vector(31 downto 0);
signal ALU_func: std_logic_vector(3 downto 0);
signal ALU_zero,ALU_ovf,ALU_Bin_sel : std_logic;

begin
    
    uut: exstage PORT MAP(
        RF_A => RF_A,
        RF_B => RF_B,
        Immed => Immed,
        ALU_Bin_sel => ALU_Bin_sel,
        ALU_func => ALU_func,
        ALU_out => ALU_out,
        ALU_zero => ALU_zero,
        ALU_ovf => ALU_ovf
    );
    
    
    simProcess: process begin
        RF_A <= x"0000abcd";
        RF_B <= x"0000dcba";
        Immed <= x"0000aaaa";
        ALU_func <="0010";
        ALU_Bin_sel <= '0';     
        wait for 100ns;
        
        RF_A <= x"0000abcd";
        RF_B <= x"0000dcba";
        Immed <= x"0000aaaa";
        ALU_func <="0011";
        ALU_Bin_sel <= '0';     
        wait for 100ns;
        
        RF_A <= x"0000abcd";
        RF_B <= x"00000000";
        Immed <= x"0000aaaa";
        ALU_func <="0101";
        ALU_Bin_sel <= '1';     
        wait for 100ns;
        
        RF_A <= x"00000000";
        RF_B <= x"0000dcba";
        Immed <= x"0000aaaa";
        ALU_func <="0000";
        ALU_Bin_sel <= '1';     
        wait for 100ns;
        
        wait;
    end process;

end Behavioral;
