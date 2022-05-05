library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2x1_5b is
    Port(
        control: in std_logic;
        A: in std_logic_vector(4 downto 0);
        B: in std_logic_vector(4 downto 0);
        Output: out std_logic_vector(4 downto 0)
    );   
end mux_2x1_5b;

architecture Behavioral of mux_2x1_5b is
begin
    Output <=  A when control='0' else B ;
end Behavioral;

