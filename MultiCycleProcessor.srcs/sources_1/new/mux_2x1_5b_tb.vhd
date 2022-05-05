library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_2x1_5b_tb is
end mux_2x1_5b_tb;

architecture Behavioral of mux_2x1_5b_tb is
    component mux_2x1_5b is
        Port(
            control: in std_logic;
            A: in std_logic_vector(4 downto 0);
            B: in std_logic_vector(4 downto 0);
            Output: out std_logic_vector(4 downto 0)
        );   
    end component;
    
    signal control: std_logic;
    signal A,B,Output: std_logic_vector(4 downto 0);
begin
    
    uut: mux_2x1_5b PORT MAP(
        control => control,
        A=>A,
        B=>B,
        Output=>Output
    );
    
    simProcess: process begin
        A<="01101";
        B<="11111";
        
        control <= '1';
        wait for 100ns;
        
        control <= '0';
        wait for 100ns;
        
        wait;
    end process simProcess;
    


end Behavioral;
