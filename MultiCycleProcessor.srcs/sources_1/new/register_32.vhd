---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: register_32 - Behavioral
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - Register Completed
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_32 is
    Port (
        --Entity inputs
        CLK: in std_logic;
        RST: in std_logic;
        WE: in std_logic;
        Datain: in std_logic_vector(31 downto 0);
        --Entity outputs
        Dataout: out std_logic_vector(31 downto 0) 
    );
end register_32;

architecture Behavioral of register_32 is

signal local_out : std_logic_vector(31 downto 0);
begin   
    process begin
        wait until CLK'EVENT AND CLK='1';
        if RST='0' then
            if WE='1' then
                local_out <= Datain;
            else 
                local_out <= local_out;
            end if;
        else
            local_out <= x"00000000";
        end if;
        
    end process;
    
    Dataout <= local_out;
    
end Behavioral;