library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rom_PC_tb is
    end;

    architecture a_rom_PC_tb of rom_PC_tb is
        
        signal clk : std_logic;
        signal contador : unsigned(6 downto 0) := "0000000";

        signal rom_endereco : unsigned(6 downto 0);
        signal rom_dado : unsigned(15 downto 0);

        signal somaum_entrada : unsigned(6 downto 0);
        signal somaum_saida : unsigned(6 downto 0);

        signal pc_wr_en : std_logic;
        signal pc_data_in : unsigned(6 downto 0);
        signal pc_data_out : unsigned(6 downto 0);

        component rom_PC is
            port (
                clk : in std_logic;

                rom_endereco : in unsigned(6 downto 0);
                rom_dado : out unsigned(15 downto 0);

                somaum_entrada : in unsigned(6 downto 0);
                somaum_saida : out unsigned(6 downto 0);

                pc_wr_en : in std_logic;
                pc_data_in : in unsigned(6 downto 0);
                pc_data_out : out unsigned(6 downto 0)
            );
        end component;
        
        begin
        uut : rom_PC port map(
            clk => clk,
            rom_endereco => rom_endereco, 
            rom_dado => rom_dado,

            somaum_entrada => somaum_entrada,    
            somaum_saida => somaum_saida,    

            pc_wr_en => pc_wr_en,    
            pc_data_in => pc_data_in,    
            pc_data_out => pc_data_out  
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