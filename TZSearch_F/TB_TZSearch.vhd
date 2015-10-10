-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  USE ieee.std_logic_unsigned.ALL;
  USE work.STD_SAD.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT Final_TZSearch
          PORT(
				CLK				: in STD_LOGIC;
				GLOBAL_START	: in STD_LOGIC;
				matA1				: in matrixSAD;
				matA2				: in matrixSAD;
				matA3				: in matrixSAD;
				matA4				: in matrixSAD;
				matB1				: in matrixSAD;
				matB2				: in matrixSAD;
				matB3				: in matrixSAD;
				matB4				: in matrixSAD;
				heightPU			: in STD_LOGIC_VECTOR(6 downto 0);
				widthPU			: in STD_LOGIC_VECTOR(6 downto 0);
				searchRange		: in STD_LOGIC_VECTOR(7 downto 0);
				initCandidateX	: in STD_LOGIC_VECTOR(7 downto 0);
				initCandidateY	: in STD_LOGIC_VECTOR(7 downto 0);
				curVecX			: out STD_LOGIC_VECTOR(7 downto 0);
				curVecY			: out STD_LOGIC_VECTOR(7 downto 0);
				bestVecX			: out STD_LOGIC_VECTOR(7 downto 0);
				bestVecY			: out STD_LOGIC_VECTOR(7 downto 0);
				done				: out STD_LOGIC
                  );
          END COMPONENT;

		signal matA1: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matA2: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matA3: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matA4: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matB1: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matB2: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matB3: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal matB4: matrixSAD := (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		signal CLK: STD_LOGIC := '0';
		signal GLOBAL_START: STD_LOGIC := '0';
		signal heightPU: STD_LOGIC_VECTOR(6 downto 0) := (OTHERS=>'0');
		signal widthPU: STD_LOGIC_VECTOR(6 downto 0) := (OTHERS=>'0');
		signal searchRange: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal initCandidateX: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal initCandidateY: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal curVecX: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal curVecY: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal bestVecX: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal bestVecY: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS=>'0');
		signal done: STD_LOGIC := '0';
          
		constant CLK_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
          Inst_TZSearch: Final_TZSearch PORT MAP(
				CLK				=> CLK,
				GLOBAL_START	=> GLOBAL_START,
				matA1 			=> matA1,
				matA2 			=> matA2,
				matA3 			=> matA3,
				matA4 			=> matA4,
				matB1 			=> matB1,
				matB2 			=> matB2,
				matB3 			=> matB3,
				matB4 			=> matB4,
				heightPU			=> heightPU,
				widthPU			=> widthPU,
				searchRange		=> searchRange,
				initCandidateX	=> initCandidateX,
				initCandidateY	=> initCandidateY,
				curVecX			=> curVecX,
				curVecY			=> curVecY,
				bestVecX			=> bestVecX,
				bestVecY			=> bestVecY,
				done				=> done
          );


	CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	

	tb: process
	begin
		GLOBAL_START <= '0';
		heightPU <= "0001000";
		widthPU <= "0010000";
		searchRange <= "01000000";
		wait for CLK_period;
		GLOBAL_START <= '1';
		wait for 5*CLK_period/2;
		
		initCandidateX <= "00010100";
		initCandidateY <= "00010100";
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00000110";
				matB2(i,j) <= "00000110";
				matB3(i,j) <= "00000110";
				matB4(i,j) <= "00000110";
			end loop;		
		end loop;
		wait for CLK_period;
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00000110";
				matB2(i,j) <= "00000110";
				matB3(i,j) <= "00000110";
				matB4(i,j) <= "00000110";
			end loop;		
		end loop;
		wait for CLK_period;
		initCandidateX <= "00010101";
		initCandidateY <= "00010101";
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00000101";
				matB2(i,j) <= "00000110";
				matB3(i,j) <= "00000110";
				matB4(i,j) <= "00000110";
			end loop;		
		end loop;
		wait for CLK_period;
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00000110";
				matB2(i,j) <= "00000110";
				matB3(i,j) <= "00000110";
				matB4(i,j) <= "00000110";
			end loop;		
		end loop;
		wait for CLK_period;
		initCandidateX <= "00010110";
		initCandidateY <= "00010110";
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00001000";
				matB2(i,j) <= "00001000";
				matB3(i,j) <= "00001000";
				matB4(i,j) <= "00001000";
			end loop;		
		end loop;
		wait for CLK_period;
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00001000";
				matB2(i,j) <= "00001000";
				matB3(i,j) <= "00001000";
				matB4(i,j) <= "00001000";
			end loop;		
		end loop;
		wait for CLK_period;
		initCandidateX <= "00010111";
		initCandidateY <= "00010111";
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00001001";
				matB2(i,j) <= "00001001";
				matB3(i,j) <= "00001001";
				matB4(i,j) <= "00001001";
			end loop;
		end loop;
		wait for CLK_period;
		for i in 0 to 3 loop
			for j in 0 to 3 loop
				matA1(i,j) <= "00000101";
				matA2(i,j) <= "00000101";
				matA3(i,j) <= "00000101";
				matA4(i,j) <= "00000101";
				matB1(i,j) <= "00001001";
				matB2(i,j) <= "00001001";
				matB3(i,j) <= "00001001";
				matB4(i,j) <= "00001001";
			end loop;
		end loop;
		wait for CLK_period;
		for i in 0 to 100 loop
			for i in 0 to 3 loop
				for j in 0 to 3 loop
					matA1(i,j) <= "00001001";
					matA2(i,j) <= "00001001";
					matA3(i,j) <= "00001001";
					matA4(i,j) <= "00001001";
					matB1(i,j) <= "00001110";
					matB2(i,j) <= "00001110";
					matB3(i,j) <= "00001110";
					matB4(i,j) <= "00001110";
				end loop;		
			end loop;
			wait for CLK_period;
			for i in 0 to 3 loop
				for j in 0 to 3 loop
					matA1(i,j) <= "00000101";
					matA2(i,j) <= "00000101";
					matA3(i,j) <= "00000101";
					matA4(i,j) <= "00000101";
					matB1(i,j) <= "00000110";
					matB2(i,j) <= "00000110";
					matB3(i,j) <= "00000110";
					matB4(i,j) <= "00000110";
				end loop;		
			end loop;
			wait for CLK_period;
		end loop;
		for i in 0 to 99999 loop
			for i in 0 to 3 loop
				for j in 0 to 3 loop
					matA1(i,j) <= "00001001";
					matA2(i,j) <= "00001001";
					matA3(i,j) <= "00001001";
					matA4(i,j) <= "00001001";
					matB1(i,j) <= "00001001";
					matB2(i,j) <= "00001001";
					matB3(i,j) <= "00001001";
					matB4(i,j) <= "00001010";
				end loop;		
			end loop;
			wait for CLK_period;
			for i in 0 to 3 loop
				for j in 0 to 3 loop
					matA1(i,j) <= "00000101";
					matA2(i,j) <= "00000101";
					matA3(i,j) <= "00000101";
					matA4(i,j) <= "00000101";
					matB1(i,j) <= "00000110";
					matB2(i,j) <= "00000110";
					matB3(i,j) <= "00000110";
					matB4(i,j) <= "00000110";
				end loop;		
			end loop;
			wait for CLK_period;
		end loop;
		wait for 9999*CLK_period;
        wait for 100 ns; -- wait until global set/reset completes
		
		wait;
	end process tb;
  --  End Test Bench 

  END;
