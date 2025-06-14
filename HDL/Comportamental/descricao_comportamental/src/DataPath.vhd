library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SelectionSort_pkg.all;

entity DataPath is
    generic (
        DATA_WIDTH  : integer := 8
    );
    port (  
        clk         : in std_logic;
        rst         : in std_logic;

        data        : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        
        -- Control path interface
        sts         : out Status;
        cmd         : in Command;
        
        -- Memory interface
        addr     : out std_logic_vector (DATA_WIDTH - 1 downto 0);
        data_in  : in std_logic_vector (DATA_WIDTH - 1 downto 0);
        data_out : out std_logic_vector (DATA_WIDTH - 1 downto 0)
    );
end DataPath;

architecture behavioral of DataPath is
    signal order, startAddr, size :   std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal i, j, min, aux, aux2                            :   std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    signal muxI, muxMin, muxInc, muxSub, MuxOrder                     :   std_logic_vector(DATA_WIDTH - 1 downto 0);
   
    signal muxData_out                     :   std_logic_vector(DATA_WIDTH - 1 downto 0);

    signal muxAddr0, MuxAddr1                                  :   std_logic_vector(DATA_WIDTH - 1 downto 0);


    signal sum                                   :   UNSIGNED(DATA_WIDTH - 1 downto 0);
    signal compDt, compAux                                   :   std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal sub                                   :   SIGNED(DATA_WIDTH - 1 downto 0);

begin

    -- registradores

	--esse registrador funciona igual a logica do logisim?
    REG_ORDER: entity work.RegisterNbits
        generic map (
            WIDTH   => 1
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrOrder,
            d       => data(0 downto 0),
            q       => order            
        );

    REG_STARTADDR: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrStartAddr,
            d       => data,
            q       => startAddr            
        );
    REG_SIZE: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrSize,
            d       => data,
            q       => size            
        );

    REG_I: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrI,
            d       => muxI,
            q       => i            
        );

    REG_MIN: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrJ,
            d       => STD_LOGIC_VECTOR(sum),
            q       => j            
        );
    REG_J: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrMin,
            d       => muxMin,
            q       => min            
        );

    REG_AUX: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrAux,
            d       => data_in,
            q       => aux            
        );

    REG_AUX2: entity work.RegisterNbits
        generic map (
            WIDTH   => DATA_WIDTH
        )
        port map (
            clk   => clk,
            rst   => rst,
            ce      => cmd.wrAux2,
            d       => data_in,
            q       => aux2            
        );

    --multiplexadores

     process(cmd.seli1, startAddr, sum)
     begin
        if cmd.selInc = '1' then
           muxI <= startAddr;
        else
           muxI <= STD_LOGIC_VECTOR(sum);
        end if;
     end process;

     process(cmd.selInc, i, j)
     begin
        if cmd.selInc = '1' then
           muxInc <= j;
        else
           muxInc <= i;
        end if;
     end process;

     process(cmd.selMin, i, j)
     begin
        if cmd.selInc = '1' then
           muxMin <= j;
        else
           muxMin <= i;
        end if;
     end process;

     process(cmd.selComp, sum, j)
     begin
        if cmd.selInc = '1' then
           muxSub <= j;
        else
           muxSub <= STD_LOGIC_VECTOR(sum);
        end if;
     end process;

     process(cmd.selAddr0, j, i)
     begin
        if cmd.selAddr0 = '1' then
           muxAddr0 <= i;
        else
           muxAddr0 <= j;
        end if;
     end process;

     process(cmd.selAddr1, muxAddr0, min)
     begin
        if cmd.selAddr1 = '1' then
           muxAddr1 <= muxAddr0;
        else
           muxAddr1 <= min;
        end if;
     end process;

	--COMPARADOR DO ORDER SE RESOLVE COMO?
     --process(order, muxAddr0, min)
    -- begin
      --  if cmd.selAddr1 = '1' then
       --    muxAddr1 <= muxAddr0;
      --  else
        --   muxAddr1 <= min;
       -- end if;
    -- end process;

     process(cmd.selData_out, Aux2, Aux)
     begin
        if cmd.selAddr1 = '1' then
           muxData_out <= Aux;
        else
           muxData_out <= Aux2;
        end if;
     end process;

    --somador
	sum <= UNSIGNED(muxInc) + 1;

    --subtrator
    sub <= SIGNED(UNSIGNED(muxSub) - UNSIGNED(size));

    --comparadorEs

    --saidas

end behavioral;
