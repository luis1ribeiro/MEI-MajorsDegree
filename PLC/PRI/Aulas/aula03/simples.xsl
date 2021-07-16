<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title> Poema transformado </title>
            </head>
            <body>
                <!-- Precisa de continuar a processar os filhos -->
                <xsl:apply-templates/> 
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="poema">
        <h2><xsl:value-of select="./titulo"/></h2>
        <h3><xsl:value-of select="autor"/></h3>
        <xsl:apply-templates select="corpo"/>
        <h4><xsl:value-of select="data"/></h4>
    </xsl:template>
    
    <xsl:template match="quadra|terceto">
        <div style="display:block; margin:30px">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="verso">
        <!-- se aplicar o valueof as tags dentro do verso não são processadas -->
        <xsl:apply-templates/>
        <br/>
    </xsl:template>
    
    <xsl:template match="nome">
        <span style="color:red">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    
</xsl:stylesheet>