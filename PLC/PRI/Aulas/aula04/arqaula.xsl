<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:result-document href="site/index.html">
            <html>
                <head>
                    <title> Arquiosstios do NW Português </title>
                </head>
                <body>
                    <h3>Índice</h3>
                    <!-- travessia indice -->
                    <ul>
                        <xsl:apply-templates select="//ARQELEM[not(CONCEL=preceding::CONCEL)]">
                            <!-- tenho q normalizar os espaços no sort, a parte do valueof -> o html trata disso --> 
                            <xsl:sort select="normalize-space(CONCEL)"/>
                        </xsl:apply-templates>
                    </ul>
                </body>
            </html>
        </xsl:result-document>
        <xsl:apply-templates select="//ARQELEM" mode="individual">         
        </xsl:apply-templates>
        <xsl:apply-templates/>
        
    </xsl:template>
    
    <xsl:template match="ARQELEM">
        <!-- para não haver ambiguidade no xsl em baixo do concelho, cria-se uma variável -->
        <xsl:variable name="c" select="CONCEL"/>
        <li>
            <!-- Ordenar dentro do Concelho -->
            <xsl:value-of select="CONCEL"/>
            <ul>
                <xsl:apply-templates mode="subindice" select="//ARQELEM[CONCEL=$c]">
                    <xsl:sort select="IDENTI"/>
                </xsl:apply-templates>
            </ul>
        </li>
    </xsl:template>
    
    <xsl:template match="ARQELEM" mode="subindice">
        <li>
            <a href="{generate-id()}.html">
                <xsl:value-of select="IDENTI"/>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template match="ARQELEM" mode="individual">
        <xsl:result-document href="site/{generate-id()}.html">
            <html>
                <head>
                    <title><xsl:value-of select="IDENTI"/></title>
                </head>
                <body>
                    <dl>
                        <xsl:for-each select="./*">
                            <dt><xsl:value-of select="name(.)"/></dt>
                            <dd><xsl:value-of select="."/></dd>
                        </xsl:for-each>
                    </dl>
                </body>
                <address>
                    [<a href="index.html">Voltar ao Indice</a>]
                </address>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>