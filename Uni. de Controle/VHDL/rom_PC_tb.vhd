library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rom_PC_tb is
    end;

    architecture a_rom_PC_tb of rom_PC_tb is
        -- variáveis
        signal clk,pc_wr_en : std_logic;
        signal rom_endereco : unsigned(6 downto 0);
        signal rom_dado,somaum_entrada,somaum_saida,pc_data_in,pc_data_out : unsigned(15 downto 0);
        -- contador
        signal contador : unsigned(6 downto 0) := "0000000";

        component rom
            port(
                clk         : in std_logic ;
                endereco    : in unsigned(6 downto 0);
                dado        : out unsigned(15 downto 0)
            );
        end component;

        component somaum
            port(
                clk     : in std_logic;
                entrada : in unsigned(15 downto 0);
                saida   : out unsigned(15 downto 0)
            );
        end component;

        component PC
            port(
                clk      : in std_logic;
                wr_en    : in std_logic;
                data_in  : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0)
            );
        end component;

        begin
        uut : rom port map(
            clk => clk,
            endereco => rom_endereco,
            dado => rom_dado,
            entrada => somaum_entrada,
            saida => somaum_saida
        );
        
        -- uut : somaum port map(
            

        -- );

        uut : PC port map(
            clk => clk,
            wr_en => pc_wr_en,
            data_in => pc_data_in,
            data_out => pc_data_out
        );

        process
        begin
            while contador /= "1111111" loop
                wait for 50 ns;
                clk <= '0';
                wait for 50 ns;
                clk <= '1';
                contador <= contador + "0000001";
            end loop;
            wait;
        end process;

    end architecture;