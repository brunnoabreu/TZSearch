----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:48:19 07/30/2015 
-- Design Name: 
-- Module Name:    UC_Raster - Behavioral 
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
use work.STD_SAD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC_Raster is
	Port(
		CLK						: in STD_LOGIC;
		START						: in STD_LOGIC;
		finishSendPartitions	: in STD_LOGIC;
		isOutOfXBound			: in STD_LOGIC;
		isOutOfYBound			: in STD_LOGIC;
		START2					: out STD_LOGIC;
		initData					: out STD_LOGIC;
		initIncrement			: out STD_LOGIC;
		incRegX					: out STD_LOGIC;
		rearrangeVecMems		: out STD_LOGIC;
		waitCycles				: out STD_LOGIC;
		validBit					: out STD_LOGIC;
		loadRegXMem2			: out STD_LOGIC;
		sendToMem				: out STD_LOGIC;
		done						: out STD_LOGIC
	);
end UC_Raster;

architecture Behavioral of UC_Raster is

type t_state is (idle, waitForStart1, waitForStart2, waitForStart3, waitForStart4, waitForStart5, waitForDone, waitLastSADs1, waitLastSADs2, waitLastSADs3, waitLastSADs4, waitLastSADs5, waitLastSADs6, waitLastSADs7, waitLastSADs8, stateDone);
signal state, nextState: t_state;
signal validBitByPass1, validBitByPass2, validBitByPass3, validBitByPass4, validBitByPass5, validBitByPass6, validBitByPass7, validBitByPass8: STD_LOGIC;
signal auxvalidBit: STD_LOGIC;

begin

process(START, CLK)
begin
	if(START='0') then
		state <= idle;
	elsif(CLK'event and CLK='1') then
		state <= nextState;
	end if;
end process;

process(state, finishSendPartitions, isOutOfXBound, isOutOfYBound)
begin
	case state is
		when idle =>
			START2 <= '0';
			initData <= '0';
			initIncrement <= '0';
			incRegX <= '0';
			waitCycles <= '0';
			auxvalidBit <= '0';
			loadRegXMem2 <= '0';
			sendToMem <= '0';
			done <= '0';
			rearrangeVecMems <= '0';
			nextState <= waitForStart1;

		when waitForStart1 =>
			nextState <= waitForStart2;
			
		when waitForStart2 =>
			initData <= '1';
			nextState <= waitForStart3;
			
		when waitForStart3 =>
			initData <= '0';
			initIncrement <= '0';
			loadRegXMem2 <= '1';
			auxvalidBit <= '0';
			incRegX <= '1';
			nextState <= waitForStart4;
			
		when waitForStart4 =>
			loadRegXMem2 <= '1';
			incRegX <= '1';
			sendToMem <= '1';
			auxvalidBit <= '1';
			initIncrement <= '1';
			nextState <= waitForDone;
			
		when waitForStart5 =>
--			loadRegXMem2 <= '0';
--			incRegX <= '0';
--			sendToMem <= '0';
--			START2 <= '1';
--			initIncrement <= '1';
--			nextState <= waitForDone;
			
		when waitForDone =>
			START2 <= '1';
			loadRegXMem2 <= '0';
			incRegX <= '0';
			sendToMem <= '0';
			rearrangeVecMems <= '0';
			if(finishSendPartitions = '1') then
				if(isOutOfXBound = '1') then
					if(isOutOfYBound = '1') then
						auxvalidBit <= '0';
						nextState <= waitLastSADs1;
					else
						rearrangeVecMems <= '1';
					end if;
				else
					sendToMem <= '1';
					loadRegXMem2 <= '1';
					incRegX <= '1';
				end if;
			end if;
			
		when waitLastSADs1 =>
			nextState <= waitLastSADs2;
			
		when waitLastSADs2 =>
			nextState <= waitLastSADs3;
			
		when waitLastSADs3 =>
			nextState <= waitLastSADs4;
			
		when waitLastSADs4 =>
			nextState <= waitLastSADs5;
			
		when waitLastSADs5 =>
			nextState <= waitLastSADs6;
			
		when waitLastSADs6 =>
			nextState <= waitLastSADs7;
			
		when waitLastSADs7 =>
			nextState <= waitLastSADs8;
			
		when waitLastSADs8 =>
			nextState <= stateDone;
			
		when stateDone =>
			initIncrement <= '0';
			done <= '1';

	end case;
	
end process;

validBit <= auxValidBit;

end Behavioral;