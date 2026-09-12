
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity completion_loop is
	generic (
		max_gate_inputs : integer := 5;
		negated_out     : boolean := true;
		mark_ko         : boolean := true;
		width           : integer := 1
	);
	port (
		ko_vector : in std_logic_vector (width - 1 downto 0);
		ko : out std_logic
	);
end completion_loop;

architecture Structural of completion_loop is
	signal output, o_mod : std_logic;
begin

	assert max_gate_inputs = 4 or max_gate_inputs = 5 report "Please select 4 or 5-input gates" severity FAILURE;

	o_mod <= '1' when negated_out else '0';

	comp: process(ko_vector)
		variable n, d : boolean;
	begin
		n := true;
		d := true;

		for ii in ko_vector'range loop
			if ko_vector(ii) = '1' then
				n := false;
			else
				d := false;
			end if;
		end loop;

		if n then
			output <= '0';
		elsif d then
			output <= '1';
		end if;
	end process comp;

	ko <= transport output xor o_mod after 1 ns;

end Structural;
