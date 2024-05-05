--  NOME: Angelo Antona. -- CODICE PERSONA: 10665838. -- MATRICOLA: 911540.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY project_reti_logiche IS
	PORT (
		i_clk : in std_logic;
		i_rst : in std_logic;
		i_start : in std_logic;
		i_w : in std_logic;
		o_z0 : out std_logic_vector(7 downto 0);
		o_z1 : out std_logic_vector(7 downto 0);
		o_z2 : out std_logic_vector(7 downto 0);
		o_z3 : out std_logic_vector(7 downto 0);
		o_done : out std_logic;
		o_mem_addr : out std_logic_vector(15 downto 0);
		i_mem_data : in std_logic_vector(7 downto 0);
		o_mem_we : out std_logic;
		o_mem_en : out std_logic);		
END project_reti_logiche;

ARCHITECTURE Behaviour OF project_reti_logiche IS
	--DICHIARO LE COMPONENTI______________________________________________
	COMPONENT Mux2to1 IS
		PORT (A, B: IN std_logic_vector(7 DOWNTO 0);
			sel: IN std_logic;
			Z: OUT std_logic_vector(7 DOWNTO 0));
	END COMPONENT;
	COMPONENT Reg IS
		PORT (DIN: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Clock,Reset: IN STD_LOGIC;
			Load: IN STD_LOGIC;
			Q: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
	--DICHIARO I SEGNALI INTERNI__________________________________________
	--Flip flop per lettura ID_uscita.
	signal o_ff: STD_LOGIC;
	signal exit_ID: STD_LOGIC_VECTOR (1 downto 0);
	--LeftShift per lettura indirizzo.
	signal LShift: STD_LOGIC_VECTOR(15 downto 0);
	--Registri regZ0, regZ1, regZ2 e regZ3 usati per memorizzare i dati da mostrare quando o_done='1'.
	signal load_regZ0, load_regZ1, load_regZ2, load_regZ3 : STD_LOGIC;
	signal o_regZ0, o_regZ1, o_regZ2, o_regZ3 : STD_LOGIC_VECTOR (7 downto 0);
	--Multiplexer che maschera l'uscita.
	signal showExits: STD_LOGIC;
	--Segnali per macchina a stati.
	type S is (reset,readID,read_addr,putInReg,done,idle);
    signal state : S;
BEGIN
    --Collego i segnali interni ai corrispondenti segnali dell'interfaccia esterna.
	o_mem_addr<=LShift;
	o_done<=showExits;
    --Processo che gestisce la macchina a stati.
    process(i_clk, i_rst)
    begin 
        o_mem_we<='0';
        if(state=reset) then --Clausola che imposta i valori dei segnali nel primissimo istante di esecuzione.
            O_mem_en<='0';
            showExits<='0';
            load_regZ0<='0';
            load_regZ1<='0';
            load_regZ2<='0';
            load_regZ3<='0';
            LShift<=(others=>'0');
            exit_ID <= "00";
        end if;
        if(i_rst='1')then --Nel caso di reset pongo tutti i segnali a default e vado in idle.
            o_mem_en<='0';
            load_regZ0<='0';
            load_regZ1<='0';
            load_regZ2<='0';
            load_regZ3<='0';
            showExits<='0';
            LShift<=(others=>'0');
            exit_ID <= "00";
            o_ff <= '0';
            state<= reset;
        elsif i_clk'event and i_clk='1' then
            case state is
                when reset=> --Attendo uno start.
                    o_mem_en<='0';
                    load_regZ0<='0';
                    load_regZ1<='0';
                    load_regZ2<='0';
                    load_regZ3<='0';
                    showExits<='0';
                    LShift<=(others=>'0');
                    exit_ID <= "00";
                    o_ff <= '0';
                    if i_start='1' then
                        o_ff <= i_w; 
                        state <= readID;
                    end if;
                when readID=> --Finisco di leggere l'ID dell'uscita.
                    load_regZ0<='0';
                    load_regZ1<='0';
                    load_regZ2<='0';
                    load_regZ3<='0';
                    showExits<='0';
                    exit_ID <= o_ff & i_w; 
                    if i_start = '1' then
                        o_mem_en<='0';
                        state<= read_addr;
                    else 
                        o_mem_en<='1';
                        state<= putInReg;
                    end if;
                when read_addr => --Leggo i bit che costituiscono o_mem_addr.
                    load_regZ0<='0';
                    load_regZ1<='0';
                    load_regZ2<='0';
                    load_regZ3<='0';
                    showExits<='0';
                    if i_start = '1' then
                        o_mem_en<='0';
                        LShift<=LShift(14 downto 0)&i_w;
                    else
                        o_mem_en<='1';
                        state <= putInReg;
                    end if;
                when putInReg => --Inserisco il dato che ricevo dalla memoria nel registro indicato da exit_ID.
                    load_regZ0<='0';
                    load_regZ1<='0';
                    load_regZ2<='0';
                    load_regZ3<='0';
                    showExits<='0';
                    o_mem_en<='1';
                    state<=done;
                    if exit_ID= "00" then 
                        load_regZ0<='1';
                    elsif exit_ID="01" then
                        load_regZ1<='1';  
                    elsif exit_ID="10" then 
                        load_regZ2<='1';  
                    else 
                        load_regZ3<='1';
                    end if;
                when done=> --L'elaborazione è finita: mostro le uscite e torno in idle.
                    state<=idle;                   
                    o_mem_en<='0';
                    showExits<='1';
                    load_regZ0<='0';
                    load_regZ1<='0';
                    load_regZ2<='0';
                    load_regZ3<='0';
                when idle=>--Mi metto in attesa, aspettando uno start.
                    o_mem_en<='0';
                    load_regZ0<='0';
                    load_regZ1<='0';
                    load_regZ2<='0';
                    load_regZ3<='0';
                    showExits<='0';
                    LShift<=(others=>'0');
                    exit_ID <= "00";
                    o_ff <= '0';
                    if i_start='1' then
                        o_ff <= i_w; 
                        state <= readID;
                    end if;
                    
            end case;
        end if;
    end process;
    --DESCRIVO LE PORT-MAP DELLE COMPONENTI_______________________________
    --Registri di uscita.
	REGZ0: Reg PORT MAP (DIN=>i_mem_data, Clock=> i_clk, Reset=> i_rst, Load=>load_regZ0, Q=>o_regZ0);
	REGZ1: Reg PORT MAP (DIN=>i_mem_data, Clock=> i_clk, Reset=> i_rst, Load=>load_regZ1, Q=>o_regZ1);
	REGZ2: Reg PORT MAP (DIN=>i_mem_data, Clock=> i_clk, Reset=> i_rst, Load=>load_regZ2, Q=>o_regZ2);
	REGZ3: Reg PORT MAP (DIN=>i_mem_data, Clock=> i_clk, Reset=> i_rst, Load=>load_regZ3, Q=>o_regZ3);
	--Multiplexer di uscita muxZ0, muxZ1, muxZ2, muxZ3.
	MUXZ0: mux2to1 PORT MAP (A=>"00000000",B=>o_regZ0,SEL=>showExits,Z=> o_z0);
	MUXZ1: mux2to1 PORT MAP (A=>"00000000",B=>o_regZ1,SEL=>showExits,Z=> o_z1);
	MUXZ2: mux2to1 PORT MAP (A=>"00000000",B=>o_regZ2,SEL=>showExits,Z=> o_z2);
	MUXZ3: mux2to1 PORT MAP (A=>"00000000",B=>o_regZ3,SEL=>showExits,Z=> o_z3);
END ARCHITECTURE;

--====================================================================================================

--REGISTRO MEMORIA________________________________________________________
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Reg IS
	PORT (DIN: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  Clock,Reset: IN STD_LOGIC;
		  Load: IN STD_LOGIC;
		  Q: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END Reg;

ARCHITECTURE Behaviour OF Reg IS
BEGIN	
	PROCESS (Clock, Reset)
		BEGIN
		IF (Reset = '1') THEN
			Q <= (OTHERS => '0');
		ELSIF (Clock'EVENT AND Clock = '1') THEN
			IF (Load='1') THEN
				Q <= DIN;
			END IF;
		END IF;
	END PROCESS;
END Behaviour;

--MUX_____________________________________________________________________
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux2to1 IS
	PORT (A, B: IN std_logic_vector(7 DOWNTO 0);
		  sel: IN std_logic;
		  Z: OUT std_logic_vector(7 DOWNTO 0));
END Mux2to1;

ARCHITECTURE Behaviour OF Mux2to1 IS
BEGIN
	
	with sel select
		Z <= A when '0',
			 B when '1',
			 (others=>'-') when others ;
END Behaviour;
