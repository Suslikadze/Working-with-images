Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity Working_with_Memory is
Generic(
	bit_pix								: integer;		--бит на счетчик пикселей
	bit_strok							: integer;		--бит на счетчик строк
	Address_cell_width					: integer;		--разрядность одной ячейки памяти
	Address_width						: integer;		--разрядность числа ячеек памяти
	Separating_width					: integer;		--разрядность выходной шины одного из цветов
	IMAGE_FILE_NAME						: string := "HOUSE_IN_BINAR.TXT"
	);

Port(
    clock								: IN STD_LOGIC;
	active_pix							: IN std_logic_vector(bit_pix - 1 downto 0);
	active_lin							: IN std_logic_vector(bit_strok - 1 downto 0);
	enable_broadcast_from_mem			: IN STD_LOGIC;
	enable_writing_in_mem				: IN std_logic;
	Data_R								: OUT std_logic_vector((Address_cell_width / 3) - 1 downto 0);
	Data_G								: OUT std_logic_vector((Address_cell_width / 3) - 1 downto 0);
	Data_B								: OUT std_logic_vector((Address_cell_width / 3) - 1 downto 0);
	flag								: OUT std_logic							
);
end Working_with_Memory;
architecture behavioral of Working_with_Memory is
-------------------------------------------------------------------------
component count_n_modul
generic (n		: integer);
port (
		clk,
		reset,
		en			:	in std_logic;
		modul		: 	in std_logic_vector (n-1 downto 0);
		qout		: 	out std_logic_vector (n-1 downto 0);
		cout		:	out std_logic);
end component;
-------------------------------------------------------------------------
signal rdaddress, wraddress			: std_logic_vector(Address_width - 1 downto 0) := (others => '0');
signal data_in_separating			: std_logic_vector(Address_cell_width-1 downto 0);
signal Number_of_addr_cells			: std_logic_vector(Address_width - 1 downto 0);

TYPE mem_type IS ARRAY(0 to 2**Address_width) OF std_logic_vector((Address_cell_width-1) DOWNTO 0);
file Reading_file	 	: text open read_mode is "HOUSE_IN_BINAR.TXT";
signal RAM	 		: mem_type;

-------------------------------------------------------------------------
Begin
Number_of_addr_cells <= std_logic_vector(to_unsigned(to_integer(signed(active_pix)) * to_integer(signed(active_lin)), Address_width));		
-------------------------------------------------------------------------
Process(clock)
variable reading_data	: bit_vector((Address_cell_width - 1) downto 0);
variable row			: line;
variable i				: integer:= 0;
Begin
	If rising_edge(clock) then
		If (not endfile(Reading_file)) then
				readline(Reading_file, row);
				read(row, reading_data);
				RAM(to_integer(unsigned(wraddress))) <= to_stdlogicvector(reading_data);
		End if;
	end if;
End process;

-------------------------------------------------------------------------
Process(clock)
Begin
If rising_edge(clock) then
	if (enable_broadcast_from_mem = '1') then
		data_in_separating <= RAM(to_integer(unsigned(rdaddress)));		
		Data_B <= data_in_separating(Separating_width - 1 downto 0);
		Data_G <= data_in_separating((Separating_width * 2) - 1 downto Separating_width);
		Data_R <= data_in_separating((Separating_width * 3) - 1 downto (Separating_width * 2));
	end if;
end if;
end process;
-------------------------------------------------------------------------	
-------------------------------------------------------------------------
Count_mem_read	: count_n_modul
	Generic map (Address_width)
	port map(
		clk			=>  clock,
		reset		=>	'0' ,
		en			=>	enable_writing_in_mem,
		modul		=>  Number_of_addr_cells, 
		qout		=>  wraddress,
		cout		=> 	flag
		);
-------------------------------------------------------------------------	
-------------------------------------------------------------------------
Count_mem_write	: count_n_modul
	Generic map (Address_width)
	port map(
		clk			=>  clock,
		reset		=>	'0' ,
		en			=>	enable_broadcast_from_mem,
		modul		=>  Number_of_addr_cells, 
		qout		=>  rdaddress
		);
-------------------------------------------------------------------------	

end behavioral;