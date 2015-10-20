----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:07:26 07/28/2015 
-- Design Name: 
-- Module Name:    UC_PredMov - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC_PredMov is
   Port(
		CLK					: in STD_LOGIC;
		START					: in STD_LOGIC;
		doneSAD				: in STD_LOGIC;
		START2				: out STD_LOGIC;
		validBit				: out STD_LOGIC;
		done					: out STD_LOGIC
	);
end UC_PredMov;

architecture Behavioral of UC_PredMov is

type t_state is (idle, s0, s1, s2, s3, stateDone);
signal state, nextState: t_state;

begin

process(CLK, START)
begin
	if(START='0') then
		state <= idle;
	elsif(CLK'event and CLK='1') then
		state <= nextState;
	end if;
end process;


process(state, doneSAD)
begin

	case state is
		when idle =>
			START2 <= '0';
			validBit <= '1';
			done <= '0';
			nextState <= s0;
		
		when s0 =>
			START2 <= '1';
			validBit <= '1';
			if(doneSAD = '0') then
				nextState <= s0;
			else
				nextState <= s1;
			end if;
		
		when s1 =>
			validBit <= '1';
			if(doneSAD = '0') then
				nextState <= s1;
			else
				nextState <= s2;
			end if;
			
		when s2 =>
			validBit <= '1';
			if(doneSAD = '0') then
				nextState <= s2;
			else
				nextState <= s3;
			end if;

		when s3 =>
			validBit <= '1';
			if(doneSAD = '0') then
				nextState <= s3;
			else
				nextState <= stateDone;
			end if;
		
		when stateDone =>
			validBit <= '1';
			done <= '1';
			nextState <= stateDone;

	end case;

end process;

end Behavioral;