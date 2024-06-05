library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regflags is
        port( clk      : in std_logic := '0';
            rst      : in std_logic := '0';
            wr_en    : in std_logic := '0';
            overflow_in  : in std_logic;
            biggest_in  : in std_logic;
            equal_in  : in std_logic;
            bit5_in : in std_logic;
            less_out : out std_logic;
            overflow_out : out std_logic;
            biggest_out : out std_logic;
            equal_out : out std_logic;
            bit5_out : out std_logic
    );
 end entity;

 architecture a_regflags of regflags is
    signal saveflow: std_logic;
    signal savebigg: std_logic;
    signal saveequa: std_logic;
    signal savebit5: std_logic;

 begin
    process(clk,rst,wr_en)  -- acionado se houver mudança em clk, rst ou wr_en
    begin                
       if rst='1' then
            saveflow <= '0';
            savebigg <= '0';
            saveequa <= '0';
            savebit5 <= '0';
       elsif wr_en='1' then
          if rising_edge(clk) then
            saveflow <= overflow_in;
            savebigg <= biggest_in;
            saveequa <= equal_in;
            savebit5 <= bit5_in;
          end if;
       end if;
    end process;
    overflow_out <= saveflow;
    biggest_out <= savebigg;
    equal_out <= saveequa;
    less_out <= '0' when rst = '1' else
                '1' when savebigg = '0' and saveequa = '0' else '0';
    bit5_out <= savebit5;
 end architecture;