---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 04/25/2022 06:24:19 PM
-- Module Name: Multi-Cycle control module 
-- Project Name: MultiCycleProcessor
-- Revision 1.00 - Module implemented
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_mc is
    Port (
        -- Global Signals
        CLK: in std_logic;
        RST: in std_logic;
        
        -- Entity inputs
        Instr: in std_logic_vector(31 downto 0);
        ALU_zero: in std_logic;
        
        -- Datapath Registers Control Signals
        Instr_Reg_WrEn: out std_logic;
        RF_A_Reg_WrEn: out std_logic;
        RF_B_Reg_WrEn: out std_logic;
        ALU_out_Reg_WrEn: out std_logic;
        MEM_Reg_WrEn: out std_logic; 
        
        -- Entity outputs
        PC_sel: out std_logic;
        PC_LdEn: out std_logic;
        ALU_func: out std_logic_vector(3 downto 0);
        ALU_bin_sel: out std_logic;
        RF_WrEn: out std_logic;
        RF_B_sel: out std_logic;
        RF_WrData_sel: out std_logic;
        ImmExt: out std_logic_vector(1 downto 0);
        Mem_WrEn: out std_logic;
        ByteOp: out std_logic        
    );
end control_mc;

architecture Behavioral of control_mc is

-- FSM States 
--
-- RESET: Get back to starting state with empty execution environment
-- FETCH: IFSTAGE instruction fetch from memory
-- DECODE: DECSTAGE instruction decomposition 
-- EXEC_R: R type ISA instruction execution
-- REG_WRITE_R: Write the result of EXEC_R state in the appropriate register
-- EXEC_I: I type ISA instruction execution
-- REG_WRITE_I: Write the result of EXEC_I state in the appropriate register
-- B_COND: Branch equal or not equal instruction control
-- B: b instruction control
-- MEM_ACTION: General memory transaction control
-- MEM_READ: Reading from memory instruction control (lw/lb)
-- L_REG: Load memory data into register after lw/lb
-- MEM_WRITE: Write to memory instruction contorl (sw/sb)
--
-- Total: 13 FSM states
--
type StateType is (RESET, FETCH, DECODE, EXEC_R, REG_WRITE_R, EXEC_I, REG_WRITE_I, B_COND, B, MEM_ACTION, MEM_READ, L_REG, MEM_WRITE);
signal state: StateType;

begin

    PROCESS BEGIN
        WAIT UNTIL CLK'EVENT AND CLK='1';
        
        -- Reset is synchronous
        if RST='1' then
            state <= RESET;
        else
            case state is
                when RESET=>
                    --Out manipulation
                when FETCH=>
                    --Out manipulation
                when DECODE=>
                    --Out manipulation                
                when EXEC_R=>
                    --Out manipulation              
                when EXEC_I=>
                    --Out manipulation                
                when REG_WRITE_R=>
                    --Out manipulation                
                when REG_WRITE_I=>
                    --Out manipulation                
                when B=>
                    --Out manipulation                
                when B_COND=>
                    --Out manipulation                
                when MEM_ACTION=>
                    --Out manipulation               
                when MEM_READ=>
                    --Out manipulation                
                when L_REG=>
                    --Out manipulation                
                when MEM_WRITE=>
                    --Out manipulation               
            end case;
        end if;
    END PROCESS;


end Behavioral;
