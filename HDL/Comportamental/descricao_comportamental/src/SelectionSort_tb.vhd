library IEEE;                        
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SelectionSort_tb is
end SelectionSort_tb;

architecture behavioral of SelectionSort_tb is      
    constant DATA_WIDTH       : integer :=  8;
    constant ADDR_WIDTH       : integer :=  8;

    signal clk                : std_logic := '0';
    signal rst, data_av       : std_logic;

    -- Entrada de dados
    signal data_in, data, data_in2      : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Saída de dados
    signal addr, dataOut, addr2, dataOut2   : std_logic_vector(DATA_WIDTH-1 downto 0);

    --Saída de dados memory
    signal dataOutMem, dataOutMem2         : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Controle da memory
    signal sel, ld, sel2, ld2              : std_logic;
    -- Saída done
    signal done, done2                     : std_logic;

begin
	
    SelectionSort_STR: entity work.SelectionSort(structural) 
    generic map (
        DATA_WIDTH    => DATA_WIDTH
    )
    port map (
        clk         => clk,
        rst         => rst,
        data_av     => data_av,
        done        => done2,
        data_in     => data_in2,
        data        => data,
        -- Memory interface
        sel         => sel2,
        ld          => ld2,
        data_out     => dataOut2,
        addr     => addr2
    );
        
    RAM_STR: entity work.memory
        generic map (
            DATA_WIDTH    => DATA_WIDTH,
            ADDR_WIDTH    => ADDR_WIDTH,
            imageFileName   => "image.txt"
        )
        port map (
            clk       => clk,
            ce          => sel2,
            wr          => ld2,
            data_in      => dataOut2,
            data_out      => dataOutMem2,
            address     => addr2
        );

		clk <= not clk after 20 ns;    -- 25 MHz
	process
	
    begin
	  report "Testbench - 2, 3, 5, 1 4, order = 1, size = 5";
        rst <= '1';
        wait until  clk = '1';
        wait until  clk = '1';
        rst <= '0';
        wait until  clk = '1';
        report "Informando posicao zero na memória para o startAddr";
        data <= (others => '0');
		data_av <= '1';
		wait until  clk = '1';
		report "informa size = 5";
		data <= "00000101";
		wait until clk = '1';
		report "informa order = 0";
		data <= "00000001";
		wait until clk = '1';
		data_av <= '0';
		
		wait until done = '1';
		
		
        

    end process;
end behavioral;
