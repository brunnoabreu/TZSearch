----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:31:46 07/13/2015 
-- Design Name: 
-- Module Name:    UC_FirstSearch - Behavioral 
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

entity UC_SAD is
	Port(
		CLK         		: in STD_LOGIC;
		START       		: in STD_LOGIC;
		waitCycles			: in STD_LOGIC;
		is8x8or16x4			: in STD_LOGIC;
		subResult			: in STD_LOGIC;
		validBit				: in STD_LOGIC;
		nrAccumSubSrc		: out STD_LOGIC;
		doneRest				: out STD_LOGIC
	);
end UC_SAD;

architecture Behavioral of UC_SAD is

type t_state is (idle, waitPipe1, waitPipe2, waitPipe3, waitPipe4, waitPipe5, waitPipe6, waitPipe7, waitPipe8,
s2Nx2N_0, s2Nx2N_1, waitFlushCycles);
signal state, nextState: t_state;

begin

	process(CLK, START)
	begin
		if(START = '0') then
			state <= idle;
		elsif(CLK'event and CLK = '1') then
			state <= nextState;
		end if;
	end process;
	
	
	process(state, subResult, is8x8or16x4, waitCycles, validBit)
	begin
	
		case state is
			when idle =>
				doneRest <= '0';
				nrAccumSubSrc <= '0';
				nextState <= waitPipe1;
				
			when waitPipe1 =>
				nextState <= waitPipe2;
				
			when waitPipe2 =>
				nextState <= waitPipe3;
				
			when waitPipe3 =>
				nextState <= waitPipe4;
				
			when waitPipe4 =>
				nextState <= waitPipe5;
				
			when waitPipe5 =>
				nextState <= waitPipe6;
				
			when waitPipe6 =>
				nextState <= waitPipe7;
				
			when waitPipe7 =>
				nextState <= waitPipe8;

			when waitPipe8 =>
--				if(is8x8or16x4 = '1') then
--					nextState <= s2Nx2N_1;
--				else
					nextState <= s2Nx2N_0;
--				end if;

			when s2Nx2N_0 =>
				doneRest <= '0';
				nrAccumSubSrc <= '1';
				nextState <= s2Nx2N_0;
				if(validBit = '0') then
					nrAccumSubSrc <= '0';
					nextState <= s2Nx2N_0;
				end if;
				if(subResult = '1') then
					doneRest <= '1';
					nrAccumSubSrc <= '0';
					nextState <= s2Nx2N_0;
				end if;
				if(waitCycles = '1') then
					--doneRest <= '0';
					nextState <= waitFlushCycles;
				end if;


--			when s2Nx2N_0 =>
--				doneRest <= '0';
--				nrAccumSubSrc <= '1';
--				nextState <= s2Nx2N_1;
--				if(validBit = '0') then
--					nrAccumSubSrc <= '0';
--					nextState <= s2Nx2N_0;
--				end if;
--				if(waitCycles = '1') then
--					nextState <= waitFlushCycles;
--				end if;
--				
			when s2Nx2N_1 =>
				if(subResult = '1') then
					doneRest <= '1';
					nrAccumSubSrc <= '0';
					nextState <= s2Nx2N_0;
					if(is8x8or16x4 = '1') then
						nextState <= s2Nx2N_1;
					end if;
					if(waitCycles = '1') then
						nextState <= waitFlushCycles;
					end if;
				else
					doneRest <= '0';
				end if;
				
			when waitFlushCycles =>
				doneRest <= '0';
				if(waitCycles = '0') then
					nextState <= waitPipe1;
				end if;
				
		end case;
	end process;
	

end Behavioral;