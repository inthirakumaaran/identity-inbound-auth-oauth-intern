CREATE TABLE IF NOT EXISTS IDN_BASE_TABLE (
            PRODUCT_NAME VARCHAR (20),
            PRIMARY KEY (PRODUCT_NAME)
);

INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server');

CREATE TABLE IF NOT EXISTS IDN_OAUTH_CONSUMER_APPS (
            ID INTEGER NOT NULL AUTO_INCREMENT,
            CONSUMER_KEY VARCHAR (255),
            CONSUMER_SECRET VARCHAR (512),
            USERNAME VARCHAR (255),
            TENANT_ID INTEGER DEFAULT 0,
            USER_DOMAIN VARCHAR(50),
            APP_NAME VARCHAR (255),
            OAUTH_VERSION VARCHAR (128),
            CALLBACK_URL VARCHAR (1024),
            GRANT_TYPES VARCHAR (1024),
            PKCE_MANDATORY CHAR(1) DEFAULT '0',
            PKCE_SUPPORT_PLAIN CHAR(1) DEFAULT '0',
            APP_STATE VARCHAR (25) DEFAULT 'ACTIVE',
            USER_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            APP_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            REFRESH_TOKEN_EXPIRE_TIME BIGINT DEFAULT 84600000,
            ID_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600000,
            CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY),
            PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE_VALIDATORS (
	APP_ID INTEGER NOT NULL,
	SCOPE_VALIDATOR VARCHAR (128) NOT NULL,
	PRIMARY KEY (APP_ID,SCOPE_VALIDATOR),
	FOREIGN KEY (APP_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS IDN_OPENID_USER_RPS (
			USER_NAME VARCHAR(255) NOT NULL,
			TENANT_ID INTEGER DEFAULT 0,
			RP_URL VARCHAR(255) NOT NULL,
			TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
			LAST_VISIT DATE NOT NULL,
			VISIT_COUNT INTEGER DEFAULT 0,
			DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
			PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
);

CREATE TABLE IF NOT EXISTS IDP (
			ID INTEGER AUTO_INCREMENT,
			TENANT_ID INTEGER,
			NAME VARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID VARCHAR(254),
			IMAGE MEDIUMBLOB,
			CERTIFICATE BLOB,
			ALIAS VARCHAR(254),
			INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
			INBOUND_PROV_USER_STORE_ID VARCHAR(254),
 			USER_CLAIM_URI VARCHAR(254),
 			ROLE_CLAIM_URI VARCHAR(254),
 			DESCRIPTION VARCHAR (1024),
 			DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
 			DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
 			PROVISIONING_ROLE VARCHAR(128),
 			IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
 			IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
 			DISPLAY_NAME VARCHAR(255),
			PRIMARY KEY (ID),
			UNIQUE (TENANT_ID, NAME));

CREATE TABLE IF NOT EXISTS IDP_AUTHENTICATOR (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            NAME VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            AUTHENTICATOR_ID INTEGER,
            PROPERTY_KEY VARCHAR(255) NOT NULL,
            PROPERTY_VALUE VARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_CLAIM (
			ID INTEGER AUTO_INCREMENT,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			CLAIM VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, CLAIM),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_CLAIM_MAPPING (
			ID INTEGER AUTO_INCREMENT,
			IDP_CLAIM_ID INTEGER,
			TENANT_ID INTEGER,
			LOCAL_CLAIM VARCHAR(253),
			DEFAULT_VALUE VARCHAR(255),
			IS_REQUESTED VARCHAR(128) DEFAULT '0',
			PRIMARY KEY (ID),
			UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
			FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_PROVISIONING_CONFIG (
            ID INTEGER AUTO_INCREMENT,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '0',
            IS_BLOCKING CHAR (1) DEFAULT '0',
            IS_RULES_ENABLED CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_ROLE (
			ID INTEGER AUTO_INCREMENT,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			ROLE VARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, ROLE),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_ROLE_MAPPING (
			ID INTEGER AUTO_INCREMENT,
			IDP_ROLE_ID INTEGER,
			TENANT_ID INTEGER,
			USER_STORE_ID VARCHAR (253),
			LOCAL_ROLE VARCHAR(253),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
			FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDP_METADATA (
            ID INTEGER AUTO_INCREMENT,
            IDP_ID INTEGER,
            NAME VARCHAR(255) NOT NULL,
            VALUE VARCHAR(255) NOT NULL,
            DISPLAY_NAME VARCHAR(255),
            TENANT_ID INTEGER DEFAULT -1,
            PRIMARY KEY (ID),
            CONSTRAINT IDP_METADATA_CONSTRAINT UNIQUE (IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

INSERT INTO IDP (TENANT_ID, NAME, CERTIFICATE) VALUES (-1234, 'LOCAL', '4d4949434e544343415a3667417749424167494553333433676a414e42676b71686b69473977304241515546414442564d517377435159445651514745774a56557a454c4d416b47413155454341774351304578466a415542674e564241634d445531766457353059576c7549465a705a5863784454414c42674e5642416f4d42466454547a4978456a415142674e5642414d4d43577876593246736147397a64444165467730784d4441794d546b774e7a41794d6a5a614677307a4e5441794d544d774e7a41794d6a5a614d465578437a414a42674e5642415954416c56544d517377435159445651514944414a44515445574d425147413155454277774e54573931626e526861573467566d6c6c647a454e4d417347413155454367774556314e504d6a45534d424147413155454177774a6247396a5957786f62334e304d4947664d413047435371475349623344514542415155414134474e4144434269514b4267514355702f6f5631765763382f546b5153694176546f75734d7a4f4d3461734232696c747232514b6f7a6e6935615646753831384d704f4c5a4972384c4d6e547a576c6c4a76766141355241416470624543622b3438466a6242653068736555644e35487077766e482f4457385a636347766b353349364f727137684c4376315a4874754f436f6b67687a2f415472687950712b516b744d66586e52533448724b474a547a7861436355374f514944415141426f7849774544414f42674e56485138424166384542414d43425041774451594a4b6f5a496876634e4151454642514144675945415735775052376372314c4164712b497252343469516c5247354954435a5859396849305079674c50327248414e682b505966546d7862754f6e796b4e4779684d36466a464c625732755a48515459316a4d725070726a4f726d794b35736a4a524f34643144654748542f596e496a73394a6f67524b763458484543774c744956644162496457484574565a4a794d536b7463797973466376756850514b3851632f452f577138754853436f3d');
INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'authenticator_name');

INSERT INTO IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY, PROPERTY_VALUE) VALUES
            (-1234, 1, 'IdPEntityId', 'LOCAL');

CREATE TABLE IF NOT EXISTS IDN_JWT_PRIVATE_KEY (JWT_ID VARCHAR(255), EXP_TIME TIMESTAMP DEFAULT 0,
TIME_CREATED TIMESTAMP DEFAULT 0, PRIMARY KEY (JWT_ID));

INSERT INTO IDN_JWT_PRIVATE_KEY (JWT_ID,EXP_TIME,TIME_CREATED)VALUES ('2000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO IDN_JWT_PRIVATE_KEY (JWT_ID,EXP_TIME,TIME_CREATED)VALUES ('2001', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO IDN_JWT_PRIVATE_KEY (JWT_ID,EXP_TIME,TIME_CREATED)VALUES ('2002', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
