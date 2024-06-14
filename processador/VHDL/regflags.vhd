library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regflags is
        port(
         clk      : in std_logic := '0';
            rst      : in std_logic := '0';
            wr_en    : in std_logic := '0';
            overflow_in  : in std_logic := '0';
            negativo_in  : in std_logic := '0';
            zero_in  : in std_logic := '0';
            bit5_in : in std_logic := '0';
            less_out : out std_logic := '0';
            overflow_out : out std_logic := '0';
            negativo_out : out std_logic := '0';
            zero_out : out std_logic := '0';
            bit5_out : out std_logic := '0'
    );
 end entity;

 architecture a_regflags of regflags is
    signal saveflow: std_logic := '0';
    signal savenega: std_logic := '0';
    signal sabezero: std_logic := '0';
    signal savebit5: std_logic := '0';

 begin
    process(clk,rst,wr_en)  -- acionado se houver mudança em clk, rst ou wr_en
    begin                
       if rst='1' then
            saveflow <= '0';
            savenega <= '0';
            sabezero <= '0';
            savebit5 <= '0';
       elsif wr_en='1' then
          if rising_edge(clk) then
            saveflow <= overflow_in;
            savenega <= negativo_in;
            sabezero <= zero_in;
            savebit5 <= bit5_in;
          end if;
       end if;
    end process;
    overflow_out <= saveflow;
    negativo_out <= savenega;
    zero_out <= sabezero;
    bit5_out <= savebit5;
 end architecture;