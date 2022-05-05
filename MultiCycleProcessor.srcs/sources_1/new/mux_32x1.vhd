---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: MUX 32 to 1 Module
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - MUX implemented
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package buses is
    --Bus of 32 signals of 32 bits
    type bus32x32 is array(31 downto 0) of std_logic_vector(31 downto 0);
end package buses;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.buses.ALL;

entity mux_32x1 is
    Port (
        input: in bus32x32;
        control: in std_logic_vector(4 downto 0);
        output: out std_logic_vector(31 downto 0)  
    );
end mux_32x1;

architecture Behavioral of mux_32x1 is

begin
    output <= input(TO_INTEGER(unsigned(control)));
end Behavioral;
