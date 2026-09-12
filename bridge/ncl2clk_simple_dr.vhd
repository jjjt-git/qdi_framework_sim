library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library qdi_framework;

entity ncl2clk_simple_dr is
	generic (
		dr_width: integer := 2
	);
	port (
		clk, rst: in std_logic;
		dri_0, dri_1: in std_logic_vector(dr_width - 1 downto 0);
		ko: out std_logic;
		valid: out std_logic;
		stall: in  std_logic;
		dro: out std_logic_vector(dr_width - 1 downto 0)
	);
end ncl2clk_simple_dr;

architecture Behavioural of ncl2clk_simple_dr is
	signal ki, ki_p, ki_s, ki_sp : std_logic;

	signal ki_vec: std_logic_vector(dr_width - 1 downto 0);

	signal ce, ko_int, valid_p: std_logic;
begin

	ki_vec <= dri_0 or dri_1;

	comp: entity qdi_framework.completion_loop
		generic map (
			width => dr_width
		) port map (
			ko_vector => ki_vec,
			ko => ki
		);

	di: process(clk) begin
		if rising_edge(clk) then
			if ki_s = '1' and ki_sp = '1' then
				dro <= dri_1;
			end if;
		end if;
	end process di;

	ki_in: process(clk, rst) begin
		if rst = '1' then
			ki_s <= '0';
			ki_p <= '0';
			ki_sp <= '0';
		else
			if falling_edge(clk) then
				if ce = '1' then
					ki_s <= ki_p;
					ki_p <= ki;
				end if;
			end if;
			if rising_edge(clk) then
				if ce = '1' then
					ki_sp <= ki_s;
				end if;
			end if;
		end if;
	end process ki_in;

	ko_int <= ki_s and ki_sp;

	ce <= not valid_p or not stall;

	valid <= valid_p;
	valid_p <= ki_sp and not ki_s;
end Behavioural;
