library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_PC is
    port(
        clk : in std_logic;
        rst : in std_logic;
        pc_wr_en : in std_logic
    );
end entity;

architecture a_rom_PC of rom_PC is

    signal rom_dado : unsigned(15 downto 0);

    signal pc_endereco_saida : unsigned(6 downto 0);
    signal rom_ : unsigned(6 downto 0);

    component PC is 
        port(
            rst      : in std_logic;
            clk      : in std_logic;
            wr_en    : in std_logic;
            saltar   : in std_logic;
            endereco_entrada  : in unsigned(6 downto 0);
            endereco_saida : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port(
            clk         : in std_logic;
            endereco    : in unsigned(6 downto 0);
            dado        : out unsigned(15 downto 0)
        );
    end component;

    begin
        PC_instance : PC port map(
            rst => rst,
            clk => clk,
            wr_en => pc_wr_en,
            data_in => somaum_saida,
            data_out => somaum_entrada
        );

        rom_instance : rom port map(
            clk => clk,
            endereco => pc_data_out,
            dado => rom_dado
        );


end architecture;


                    
