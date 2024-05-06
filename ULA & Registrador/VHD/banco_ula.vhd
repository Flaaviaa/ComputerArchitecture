library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_ula is
    port (  clk                        : in std_logic;
            rst                        : in std_logic;
            wr_en                      : in std_logic;
            mux_select                 : in std_logic; 
            operacao_ula               : in unsigned(1 downto 0);
            select_reg_1               : in unsigned(2 downto 0);
            select_reg_2               : in unsigned(2 downto 0);
            valor_entrada              : in unsigned(15 downto 0);
            regWrite                   : in unsigned(2 downto 0);
            result                     : out unsigne(15 downto 0)
    );
end entity;

architecture a_banco_ula of banco_ula is
    -- cria o banco de registradores
    component banco_de_registradores is
        port (  reg_select_1      : in unsigned(2 downto 0);
                reg_select_2      : in unsigned(2 downto 0);     
                regWrite          : in unsigned(2 downto 0);
                entr              : in unsigned(15 downto 0);
                wr_en             : in std_logic;
                clk               : in std_logic;
                rst               : in std_logic;
                reg_data1         : out unsigned(15 downto 0) := "0000000000000000";  
                reg_data2         : out unsigned(15 downto 0) := "0000000000000000" 
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
    signal saida_ula, saida_reg_1, saida_reg_2, mux_output  : unsigned(15 downto 0);

    begin
        -- mapeia as portas do registrador
    banco_de_registradores_instance: banco_de_registradores
    port map(   
        reg_select_1    =>  select_reg_1,
        reg_select_2    =>  select_reg_2,
        regWrite        =>  regWrite,
        entr            =>  saida_ula,
        wr_en           =>  wr_en,
        clk             =>  clk,
        rst             =>  rst,
        reg_data1       =>  saida_reg_1,
        reg_data2       =>  saida_reg_2
    );
    
        -- mapeia as portas da ULA
    ula_instance: ULA 
    port map(   
        ina => saida_reg_1,
        inb => mux_output,
        operationselect => operacao_ula,
        result => saida_ula
    );
    
        -- define qual saída vamos utilizar, do registrador ou da entrada pré definida
    mux_output <= 
        saida_reg_2 when mux_select = '0' else
        valor_entrada when mux_select = '1' else
        "0000000000000000"; 

        -- grava o resultado para utilizar nos testes
        result <= saida_ula;

	end architecture;
	