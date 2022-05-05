---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: Decoder 5x32 Module
-- Project Name: SingleCycleProcessor
-- Revision 1.1 - Updated behavioral to be more efficient
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder_5x32 is
    Port (
        input: in std_logic_vector(4 downto 0);
        output: out std_logic_vector(31 downto 0)   
    );
end decoder_5x32;

architecture Behavioral of decoder_5x32 is

begin
    
    output <= (TO_INTEGER(unsigned(input)) => '1', others=>'0') after 10ns;
    
end Behavioral;
