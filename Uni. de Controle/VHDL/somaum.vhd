library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somaum is
    port ( 
        clk     : in std_logic;
        entrada : in unsigned(15 downto 0);
        saida   : out unsigned(15 downto 0)
    );
end entity;

architecture a_somaum of somaum is
    component PC is
        port (  
            clk      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0);
            result   : out unsigned(11 downto 0)
        );
    end component;


    signal saida_maisum: unsigned(15 downto 0);

    begin

        PC_instance: PC
        port map(   
            clk => clk,
            wr_en => '1',
            data_in => saida_maisum, -- valor de entrada + 1
            data_out => result,
            result => '0'
        );

        saida_maisum <= entrada + "0000000000000001";
end architecture;
	