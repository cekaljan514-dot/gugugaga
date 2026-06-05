Firemní organigram SILON

Přehledný a jednoduchý organigram s jménem a pozicí zaměstnanců s možností vyhledávání.

-------------------------------------------------

INSTALAČNÍ INSTRUKCE:

1. Aktivování IIS - Zapněte "Zapnout nebo vypnout funkce systému Windows" a zaškrtněte "Internetová informační služba", poté jdetě do "Internetová informační služba" -> "Webové služby" -> "Funkce pro vývoj aplikací" a zaškrtněte "CGI". Server otevřete napsáním "localhost" do internetu a všechny instalované soubory dáte do složky C:\inetpub\wwwroot

2. Stažení a konfigurace PHP - Jděte na stránku https://www.php.net/downloads.php a stáhněte si Non-Thread Safe 8.5.x verzi PHP. Rozbalte ZIP archiv, zkopírujte si soubor php.ini-development a přejmenujte ho na php.ini. Otevřete ho v libovolném textovém editoru a smažte středník na začátku řádku u "extension_dir = "ext"" a "extension=pdo_mysql".

3. Registrace v IIS - Otevřete "Správce služby IIS" (zmáčkněte Win+R a napište inetmgr), otevřete "Mapování obslužných rutin", vlevo klikněte na "Přidat mapování modulů" a vyplňte následující údaje: Cesta požadavků = *.php, Modul = FastCgiModule, Spustitelný program = php-cgi.exe (najdete ve složce kde jste rozbalili ZIP s PHP) a libovolný název.

4. Otevřete employees.php ve složce C:\inetpub\wwwroot\api a změnte nahoře $host, $name, $password a $dbname na vaše údaje.

Databázovou tabulku strukturuje podle následujícího SQL příkazu:

CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Vytvoření tabulky zaměstnanců (Employees)
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(100) NOT NULL,
    company VARCHAR(100) NOT NULL,
    department_id INT NULL,
    parent_id INT NULL,
    -- Definice cizích klíčů pro zajištění integrity
    CONSTRAINT fk_department 
        FOREIGN KEY (department_id) 
        REFERENCES departments(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_parent_employee 
        FOREIGN KEY (parent_id) 
        REFERENCES employees(id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-------------------------------------------------

Architektura aplikace

Data tečou z externí databáze, poté jsou zpracována do stromové struktury v PHP API, která je přečtené pomocí fetch a následně zobrazená v JavaScriptu a nakonec zkrášlená pomocí CSS.

-------------------------------------------------

Dokumentace vyvibeovaného pluginu

Plugin se automaticky inicializuje při každém načtení stránky. Jako své vstupní data použivá API Endpoint a strukturu uzle zaměstnanců. Použivá metody loadEmployees(), která načte data ze serveru a vykreslí organigram, applySearchFilter(query:string) která filtruje a zvýrazňuje uzly podle vyhledávacího dotazu, toggleNode(node:Object) pro rozbalení a sbalení podřízených uzlů daného uzlu, randerOrganigram(nodes:Array) pro vykreslení seznamu kořenových uzlů do DOM a setSearchMatch(node:Object, query:string): boolean která rekurzivně označí uzly odpovídajících dotazů.