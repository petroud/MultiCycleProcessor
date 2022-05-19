library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity proc_mc_tb is
end proc_mc_tb;

architecture Behavioral of proc_mc_tb is

    component proc_mc is
        Port(
            CLK: in std_logic;
            RST: in std_logic
        );
    end component;

signal CLK,RST,inner_termin: std_logic;


begin

    uut: proc_mc PORT MAP(
        CLK=>CLK,
        RST=>RST
    );

    simProcess: process begin
        
        RST<='1';
        wait for 200ns;
        RST<='0';        
        
        wait;
    end process;
    
    
    --Process for generating clock signal 
    clkProcess: process begin
        --Vary the clock signal for low to high every 30ns 
        --Period = 20ns
        CLK <= '0';
        wait for 100ns;
        CLK <= '1';
        wait for 100ns;
        
        --The terminationg flag will be HIGH after a certain time 
        --The clock is generated for this amount of time 
        inner_termin<='1' after 20000000ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;


end Behavioral;
