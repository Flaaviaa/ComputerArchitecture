library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_UC is
    port ( 
        clk: in std_logic
    );
end entity;

architecture a_proto_UC of proto_UC is
    -- cria o PC
    component PC is
        port (  
            clk      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0) 
        );
    end component;

    -- cria a ula
    component ULA is
        port (  ina : in unsigned(15 downto 0);
                inb : in unsigned(15 downto 0);
                operationselect : in unsigned(1 downto 0);
                carry : out std_logic;
                overflow : out std_logic;
                biggest : out std_logic;
                equal : out std_logic;
                result : out unsigned(15 downto 0)
        );
    end  component;

    -- declara os sinais usados no processamento
    signal saida_ula, entrada_ula  : unsigned(15 downto 0);

    begin
        -- mapeia as portas do program counter
    PC_instance: PC
    port map(   
        clk => clk,
        wr_en => '1',
        data_in => saida_ula, -- valor de entrada + 1
        data_out => entrada_ula
    );
    
        -- mapeia as portas da ULA
    ula_instance: ULA 
    port map(   
        ina => '0000000000000001', --1
        inb => entrada_ula, --valor do PC
        operationselect => '00', --soma
        result => saida_ula
    );
    
	end architecture;
	