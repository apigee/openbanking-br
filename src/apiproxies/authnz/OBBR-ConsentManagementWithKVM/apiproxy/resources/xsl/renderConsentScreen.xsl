<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <!-- This XSLT dynamically generates the consent screen. -->
    <!-- Currently displays permissions related to Accounts and Customer information but can be easily extended to include all other permissions -->
    <xsl:output method="html" encoding="utf-8" indent="yes" />
    <xsl:param name="scope" select="''" />
    <xsl:param name="clientName" select="'Portal Test App'" />
    <xsl:param name="consentCacheKey" select="'testConsentId'" />
    <xsl:param name="consentExpiryDate" select="'2029-12-31T08:30:00Z'" />
    <xsl:param name="loggedUser" select="'CPF 11111111111'" />
    <xsl:param name="businessEntity" select="''" />
    <xsl:param name="permissionsString" select="'ACCOUNTS_READ ACCOUNTS_BALANCES_READ ACCOUNTS_TRANSACTIONS_READ ACCOUNTS_OVERDRAFT_LIMITS_READ RESOURCES_READ'" />
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <script>
                    function changeConsentStatusAndSubmit(value) {
                    document.getElementById("consent-status").value = "REJECTED";
                    document.getElementById("consentForm").submit();
                    }
                </script>
                <style>
                    body {
                    background-color: #fcfcfa;
                    text-align: center;
                    font-size: 1em;
                    font-family: Arial, Helvetica, sans-serif;
                    }
                    
                    h1 {
                    color: rgb(52, 109, 242);
                    }
                    
                    form {
                    text-align: center;
                    margin: 1em 2em;
                    }
                    
                    table {
                    width: 100%;
                    max-width: 450px;
                    margin: auto;
                    }
                    
                    .confirm-label {
                    font-weight: 500;
                    text-align: left;
                    }
                    
                    .scope-label {
                    font-weight: 500;
                    text-align: left;
                    }
                    
                    .form-label {
                    font-weight: 500;
                    text-align: left;
                    }
                    
                    button {
                    background: rgb(2, 109, 242);
                    color: white;
                    padding: 10px 25px;
                    border-radius: 10px;
                    font-size: 1em;
                    margin: 10px;
                    }
                    
                    .description {
                    color: #595959;
                    text-align: top;
                    font-style: italic;
                    font-size: smaller;
                    }
                    
                    .input:focus {
                    outline-color: rgb(2, 109, 242);
                    }
                </style>
            </head>
            
            <body>
                <header>
                    <img border="0" alt="Open Bank" src="data:image/jpeg;base64,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" width="250" />
                    <h1 style="margin-left:10px;">Consent</h1>
                </header>
                <form id="consentForm" autocomplete="off" method="post">
                    <xsl:attribute name="action">
                        <xsl:text>/consent-mgmt-with-kvm/consents/interaction/</xsl:text>
                        <xsl:value-of select="$consentCacheKey" />
                    </xsl:attribute>
                    <input name="consent-status" type="hidden" id="consent-status" value="AUTHORISED" />
                    <table width="100%">
                        <col style="width:40%" />
                        <col style="width:60%" />
                        <tr style="height: 15px;"></tr>
                        <tr>
                            <td class="confirm-label" colspan="2">Please confirm that you agree to share the following data with
                                <b><xsl:value-of select="$clientName"/></b>
                            </td>
                        </tr>
                        <tr style="height: 15px;"></tr>
                        <tr class="form-label">
                            <td>End user identification:</td>
                            <td><xsl:value-of select="$loggedUser"/></td>
                        </tr>
                        <xsl:if test="$businessEntity != ''">
                            <tr class="form-label">
                                <td>Business identification:</td>
                                <td><xsl:value-of select="$businessEntity"/></td>
                            </tr>
                        </xsl:if>
                        <tr>
                            <td class="form-label">Expiry Date:</td>
                            <td><xsl:value-of select="format-dateTime(xs:dateTime($consentExpiryDate),'[D01]/[M01]/[Y0001]')"/></td>
                        </tr>
                    </table> 
                    <table>
                        <tr style="height: 15px;"></tr>
                        <tr>
                            <td class="scope-label">Select accounts to share data</td>
                        </tr>                
                        <tr style="height: 15px;"></tr>
                        <xsl:for-each select="/resources/resource">
                            <tr>
                                <td>
                                    <label><xsl:value-of select="description"/></label>
                                </td>
                                <td><input type="checkbox">
                                        <xsl:attribute name="name"><xsl:value-of select="type" /></xsl:attribute>
                                        <xsl:attribute name="id"><xsl:value-of select="id" /></xsl:attribute>
                                        <xsl:attribute name="value"><xsl:value-of select="id" /></xsl:attribute>
                                    </input>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                    <table>
                        <tr style="height: 15px;"></tr>
                        <xsl:if test="contains($permissionsString,'CUSTOMERS')">
                            <!-- There is at least one permission related to customer information. Generate this section-->
                            <tr>
                                <td class="form-label">
                                    <label>
                                        Dados Cadastrais (Customer Information)
                                        <ul>
                                            <xsl:if test="contains($permissionsString,'CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ')">
                                                <span class="description">
                                                    <li>Identificação Pessoa Natural (Personal Information)</li>
                                                </span>
                                            </xsl:if>
                                            <xsl:if test="contains($permissionsString,'CUSTOMERS_PERSONAL_ADITTIONALINFO_READ')">
                                                <span class="description">
                                                    <li>Informação Adicional Pessoa Natural: Relacionamento financeiro e qualificação
                                                        financeira (Additional Personal Information)</li>
                                                </span>
                                            </xsl:if>
                                            <xsl:if test="contains($permissionsString,'CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ')">
                                                <span class="description">
                                                    <li>Identificação Pessoa Jurídica (Business Information)</li>
                                                </span>
                                            </xsl:if>
                                            <xsl:if test="contains($permissionsString,'CUSTOMERS_BUSINESS_ADITTIONALINFO_READ')">
                                                <span class="description">
                                                    <li>Informação Adicional Pessoa Jurídica: Relacionamento financeiro e qualificação
                                                        financeira (Additional Business Information)</li>
                                                </span>
                                            </xsl:if>
                                        </ul>
                                    </label>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="contains($permissionsString,'ACCOUNTS')">
                            <!-- There is at least one permission related to customer information. Generate this section-->
                            <tr>
                                <td class="form-label">
                                    <label>
                                        Dados de Contas (Account Information)
                                        <ul>
                                            <xsl:if test="contains($permissionsString,'ACCOUNTS_READ')">
                                                <span class="description">
                                                    <li>Lista de contas e dados de identificação das contas (List of accounts)</li>
                                                </span>
                                            </xsl:if>
                                            <xsl:if test="contains($permissionsString,'ACCOUNTS_BALANCES_READ')">
                                                <span class="description">
                                                    <li>Saldos de contas (Account balances)</li>
                                                </span>
                                            </xsl:if>
                                            <xsl:if test="contains($permissionsString,'ACCOUNTS_TRANSACTIONS_READ')">
                                                <span class="description">
                                                    <li>Transações de contas (Account transactions)</li>
                                                </span>
                                            </xsl:if>
                                            <xsl:if test="contains($permissionsString,'ACCOUNTS_OVERDRAFT_LIMITS_READ')">
                                                <span class="description">
                                                    <li>Limites de contas (Account limits)</li>
                                                </span>
                                            </xsl:if>
                                        </ul>
                                    </label>
                                </td>
                            </tr>
                        </xsl:if>
                        <tr style="height: 15px;"></tr>
                        <tr style="height: 15px;"></tr>
                        <tr style="text-align: center;">
                            <td>
                                <button type="submit1" id="submit1" class="login login-submit">Authorise</button>
                                <button type="button" id="cancel" class="login login-submit"
                                        onClick="changeConsentStatusAndSubmit()">Deny</button>
                            </td>
                        </tr>
                    </table>
                    
                </form>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>