library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity pc_adder is
    Port (
        PC_Immed: in std_logic_vector(31 downto 0);
        PC_Norm: in std_logic_vector(31 downto 0);
        
        --PC+4
        Output_Incr: out std_logic_vector(31 downto 0);
        
        --PC+4 + Immed
        Output_Immed: out std_logic_vector (31 downto 0)
    );
end pc_adder;

architecture Behavioral of pc_adder is

begin

    Output_Incr <= PC_Norm + 4;
    Output_Immed <= PC_Norm + 4 + PC_Immed;
   
end Behavioral;
