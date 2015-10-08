----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:51:32 09/26/2014 
-- Design Name: 
-- Module Name:    calcSAD - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.ALL;
use work.STD_SAD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blck4x4 is
	Port(
		matA 		 : in matrixSAD;
		matB 		 : in matrixSAD;
		clk, start: in std_logic;
		S    		 : out std_logic_vector(8 + log2_total - 1 downto 0	));
end blck4x4;

architecture Behavioral of blck4x4 is

component genericAdder is
	generic(
				WIDTHX : integer
	);
	port(
			a: in std_logic_vector(widthX-1 downto 0);
			b: in std_logic_vector(widthX-1 downto 0);
			c: out std_logic_vector(widthX downto 0)
	);
end component;

component genericSub is
	port(
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector(7 downto 0);
			c: out std_logic_vector(7 downto 0)
	);
end component;

-- type signalArray8b is array(0 to log2_unsigned(TOTAL)-1, 0 to TOTAL/2-1) of std_logic_vector(7+log2_unsigned(TOTAL)-1 downto 0); --0 to log2_unsigned(TOTAL)-1, 0 to TOTAL/2-1, 7+log2_unsigned(TOTAL)-1
type t_subArray is array(0 to 15) of std_logic_vector (7 downto 0);
type t_firstAdder is array(0 to 7) of std_logic_vector(8 downto 0);
type t_secAdder is array(0 to 3) of std_logic_vector(9 downto 0);
type t_thirdAdder is array(0 to 1) of std_logic_vector(10 downto 0);

	signal regSubVec, subVec: t_subArray;
	signal regFirstAdder, firstAdder: t_firstAdder;
	signal regSecondAdder, secondAdder: t_secAdder;
	signal regThirdAdder, thirdAdder: t_thirdAdder;
	signal regSAD, outSAD: STD_LOGIC_VECTOR(11 downto 0);

begin

	process(clk, start)
	begin
		if(start='0') then
			regSubVec <= (OTHERS => (OTHERS =>'0'));
			regFirstAdder <= (OTHERS=>(OTHERS=>'0'));
			regSecondAdder <= (OTHERS=>(OTHERS=>'0'));
			regThirdAdder <= (OTHERS=>(OTHERS=>'0'));
			regSAD <= (OTHERS=>'0');
		elsif(clk'event and clk='1') then
			regSubVec <= subVec;
			regSAD <= outSAD;
			for i in 0 to 7 loop
				regFirstAdder(i) <= firstAdder(i);
			end loop;
			for i in 0 to 3 loop
				regSecondAdder(i) <= secondAdder(i);
			end loop;
			for i in 0 to 1 loop
				regThirdAdder(i) <= thirdAdder(i);
			end loop;
		end if;
	
	end process;

		gen0: for i in 0 to WIDTH2-1 generate
			gen01: for j in 0 to height2-1 generate
				subX: genericSub
					port map(matA(i,j), matB(i,j), subVec(WIDTH2*i+j)); -- SUBTRATORES
			end generate gen01;
		end generate gen0;

		gen1: for i in 0 to 3 generate
			gen2: for j in 0 to (TOTAL/(2**(i+1)))-1 generate
				gen3: if i = 0 generate
					add0: genericAdder -- PRIMEIRO SOMADOR
						generic map( WIDTHX => 8 + i)	port map(regSubVec(j*2), regSubVec(j*2+1), firstAdder(j)(8+i downto 0));
				end generate gen3;

				gen4: if i=1 generate
					addx: genericAdder -- SEGUNDO SOMADOR
						generic map( widthX => 8 + i)	port map(regFirstAdder(j*2), regFirstAdder(j*2+1), secondAdder(j)(8+i downto 0));
				end generate gen4;				

				gen35: if i=2 generate
					add05: genericAdder -- TERCEIRO SOMADOR
						generic map( WIDTHX => 8 + i) port map(regSecondAdder(j*2), regSecondAdder(j*2+1), thirdAdder(j)(8+i downto 0));
				end generate gen35;
				
				gen5: if i = 3 generate
					addF: genericAdder -- SOMADOR DA SAÍDA (ANTES DE SER REGISTRADO)
						generic map( widthX => 8 + i) port map(regThirdAdder(0), regThirdAdder(1), outSAD(8+i downto 0));
				end generate gen5;
				
			end generate gen2;
		end generate gen1;

		S <= regSAD; -- SOMADOR DA SAÍDA JÁ REGISTRADO
		

end Behavioral;