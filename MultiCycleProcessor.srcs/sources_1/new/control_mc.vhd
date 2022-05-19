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
type StateType is (RESET, FETCH, DECODE, EXEC_R, REG_WRITE_R, EXEC_I, REG_WRITE_I, B, B_COND, B_COND_COMPLETE, MEM_ACTION, MEM_READ, L_REG, MEM_WRITE);
signal present_state: StateType;
signal next_state: StateType;
signal branch_pc: std_logic;

begin


    PROCESS (CLK,RST)
    BEGIN
        if (RST='1') then
            present_state<= RESET;
        elsif (rising_edge(CLK)) then
            present_state<= next_state;
        end if;
    end process;
    
    

    PROCESS(present_state,Instr, ALU_zero)
    BEGIN        
            branch_pc <= '0';
           
            case present_state is
            
                when RESET=>
                
                    PC_sel <= '0';
                    PC_LdEn <= '0';
                    ALU_func <= "----";
                    ALU_bin_sel <= '-';
                    RF_WrEn <= '0';
                    RF_B_sel <= '-';
                    RF_WrData_sel <= '-';
                    ImmExt <= "--";
                    Mem_WrEn <= '0';
                    ByteOp <= '-';
                    
                    Instr_Reg_WrEn <= '1';
                    RF_A_Reg_WrEn <= '0';
                    RF_B_Reg_WrEn <= '0';
                    ALU_out_Reg_WrEn <= '0';
                    MEM_Reg_WrEn <= '0'; 
                    
                    next_state <= FETCH;
                    
                when FETCH=>
                    
                    PC_LdEn <= '0';
                    
                    RF_WrEn <= '0';                    
                    Instr_Reg_WrEn <= '1';
                    RF_A_Reg_WrEn <= '1';
                    RF_B_Reg_WrEn <= '1';
                    ALU_out_Reg_WrEn <= '1';
                    MEM_Reg_WrEn <= '1'; 
                    
                    next_state <= DECODE;
                    
                when DECODE=>
                    
                    PC_sel <= '0';
                    branch_pc <= '0';
                    PC_LdEn <= '0';
                    ALU_func <= "0000";
                    ALU_bin_sel <= '-';
                    RF_WrEn <= '0';
                    RF_B_sel <= '0';
                    RF_WrData_sel <= '0';
                    ImmExt <= "--";
                    Mem_WrEn <= '0';
                    ByteOp <= '-';
                    
                    Instr_Reg_WrEn <= '0';
                    RF_A_Reg_WrEn <= '1';
                    RF_B_Reg_WrEn <= '1';  
                    ALU_out_Reg_WrEn <= '1';
                    MEM_Reg_WrEn <= '1';
                    
                    if(Instr(31 downto 26)="100000") then
                        next_state <= EXEC_R;
                    elsif (Instr(31 downto 30)="11" AND Instr(28) = '0') then
                        next_state <= EXEC_I;
                    elsif (Instr(31 downto 26)="111111") then
                        next_state <= B;
                    elsif (Instr(31 downto 26)="000000" OR Instr(31 downto 26)="000001") then
                        next_state <= B_COND;
                    elsif (Instr(31 downto 26)="000011" OR Instr(31 downto 26)="000111" OR Instr(31 downto 26)="001111" or Instr(31 downto 26) ="011111") then
                        next_state <= MEM_ACTION;
                    end if;
                                       
                when EXEC_R=>
                
                    PC_sel <= '0';
                    PC_LdEn <= '0';
                    ALU_func <= Instr(3 downto 0);
                    ALU_bin_sel <= '0';
                    RF_WrEn <= '0';
                    RF_B_sel <= '0';
                    RF_WrData_sel <= '1';
                    ---------------------
                    ImmExt <= "--";
                    ---------------------
                    Mem_WrEn <= '0';
                    ByteOp <= '-';
               
                    next_state <= REG_WRITE_R;
                               
                when EXEC_I=>
                
                    PC_sel <= '0';
                    PC_LdEn <= '0';
                    
                    if(Instr(28 downto 26)="000" OR Instr(28 downto 26)="001") then
                        ALU_func <= "0000";
                    elsif(Instr(28 downto 26)="010") then
                        ALU_func <= "0101";
                    elsif(Instr(28 downto 26)="011") then
                        ALU_func <= "0011";
                    end if;
                                        
                    ALU_bin_sel <= '1';
                    RF_WrEn <= '0';
                    RF_B_sel <= '1';
                    RF_WrData_sel <= '1';
                    
                    if(Instr(28 downto 26)="000") then
                        ImmExt <= "01";
                    elsif(Instr(28 downto 26)="001") then
                        ImmExt <= "11";
                    elsif(Instr(28 downto 26)="010" OR Instr(28 downto 26)="011") then
                        ImmExt <= "00";
                    end if;
                                        
                    Mem_WrEn <= '0';
                    ByteOp <= '-';
                    
                    next_state <= REG_WRITE_I;   
                                 
                when REG_WRITE_R=>
                  
                    RF_WrEn <= '1';
                    PC_LdEn <= '1';
                    Instr_Reg_WrEn <= '1';

                    next_state <= FETCH;                    
             
                when REG_WRITE_I=>
                    
                    RF_WrEn <= '1';
                    Instr_Reg_WrEn <= '1';
                    PC_LdEn <= '1';

                    next_state <= FETCH;
                                    
                when B=>
                                                    
                    PC_sel <= '1';
                    ALU_func <= "0000";
                    ALU_bin_sel <= '0';
                    RF_WrEn <= '0';
                    RF_B_sel <= '0';
                    RF_WrData_sel <= '1';
                    ImmExt <= "10";
                    Mem_WrEn <= '0';
                    ByteOp <= '-';   
                    Instr_Reg_WrEn <= '1';
                    PC_LdEn <= '1';

                    next_state <= FETCH;

                when B_COND=>
                   
                    ALU_func <= "0001";
                    ALU_bin_sel <= '0';
                    RF_WrEn <= '0';
                    RF_B_sel <= '1';
                    RF_WrData_sel <= '1';
                    ImmExt <= "10";
                    Mem_WrEn <= '0';
                    ByteOp <= '-';
                                        
                    next_state <= B_COND_COMPLETE;                
               
                when B_COND_COMPLETE=>
                    if(Instr(26)='0' AND ALU_zero='1') then
                        PC_sel <= '1';
                    elsif(Instr(26)='1' AND ALU_zero='0') then
                        PC_sel <= '1';
                    else
                        PC_sel <= '0';
                    end if;
                    Instr_Reg_WrEn <= '1';
                    PC_LdEn <= '1';
          
                    next_state <= FETCH;
                                                       
                when MEM_ACTION=>
                
                    ALU_bin_sel <= '1';
                    RF_WrData_sel <= '0';
                    ALU_func <= "0000";
                    ImmExt <= "01";
                    
                    if(Instr(31 downto 26)="000011" OR Instr(31 downto 26)="000111") then
                        ByteOp <='0';
                    else
                        ByteOp <='1';
                    end if;
                    
                    if(Instr(31 downto 26)="000011" OR Instr(31 downto 26)="001111") then
                        next_state <= MEM_READ;
                    elsif(Instr(31 downto 26)="011111" OR Instr(31 downto 26)="000111") then
                        next_state <= MEM_WRITE;
                    end if;       
                    
                    
                when MEM_READ=>
                    
                    RF_B_sel <= '0';
                    next_state <= L_REG;               
    
                when L_REG=>
                    
                    RF_WrEn <= '1';
                    PC_LdEn <= '1';
                    next_state <= FETCH;
                                                 
                when MEM_WRITE=>
                
                    Mem_WrEn <= '1';
                    RF_B_sel <= '1';
                    PC_LdEn <= '1';
                    next_state <= FETCH;
                    
             end case;
         
    END PROCESS;

end Behavioral;
