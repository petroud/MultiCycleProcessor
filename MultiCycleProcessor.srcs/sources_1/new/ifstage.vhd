---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: IFSTAGE - Behavioral Module
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ifstage is
    Port (
        -- Entity inputs
        PC_Immed: in std_logic_vector(31 downto 0);
        PC_sel: in std_logic;
        PC_LdEn: in std_logic;
        RST: in std_logic;
        CLK: in std_logic;
        -- Entity outputs
        PC: out std_logic_vector(31 downto 0)
    );
end ifstage;

architecture Behavioral of ifstage is
    
    --PC register of 32 bits
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
    end component;
    
    -- 2x1 MUX 
    component mux_2x1 is
        Port(
            control: in std_logic;
            A: in std_logic_vector(31 downto 0);
            B: in std_logic_vector(31 downto 0);
            Output: out std_logic_vector(31 downto 0)
        );   
    end component;
    
    -- The adder-incrementor module
    component pc_adder is
        Port (
            PC_Immed: in std_logic_vector(31 downto 0);
            PC_Norm: in std_logic_vector(31 downto 0);
            --PC+4
            Output_Incr: out std_logic_vector(31 downto 0);
            --PC+4 + Immed
            Output_Immed: out std_logic_vector (31 downto 0)
         );
    end component;
    
    signal Output_Incr, Output_Immed, Output_MUX, Output_PCreg: std_logic_vector(31 downto 0);
    
begin

    pc_reg: register_32 PORT MAP(
        CLK => CLK,
        RST => RST,
        WE => PC_LdEn,
        Datain=> Output_MUX,
        Dataout=> Output_PCreg
    );
    
    mux: mux_2x1 PORT MAP(
        control=>PC_sel,
        A=>Output_Incr,
        B=>Output_Immed,
        Output=>Output_MUX
    );    
    
    adder: pc_adder PORT MAP(
        PC_Immed => PC_Immed,
        PC_Norm => Output_PCreg,
        Output_Incr => Output_Incr,
        Output_Immed => Output_Immed
    );
    
    PC <= Output_PCreg;


end Behavioral;
