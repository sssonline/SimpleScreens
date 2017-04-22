<#--
This software is in the public domain under CC0 1.0 Universal plus a Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->

<#-- See the mantle.account.InvoiceServices.get#ReceivableStatementInfo service for data preparation -->

<#assign cellPadding = "4pt">
<#assign tableFontSize = tableFontSize!"10pt">
<#assign dateTimeFormat = dateTimeFormat!"dd MMM yyyy HH:mm">
<#assign dateFormat = dateFormat!"dd MMM yyyy">

<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Helvetica, sans-serif" font-size="10pt">
    <fo:layout-master-set>
        <fo:simple-page-master master-name="letter-portrait" page-width="8.5in" page-height="11in"
                               margin-top="0.5in" margin-bottom="0.5in" margin-left="0.5in" margin-right="0.5in">
            <fo:region-body margin-top="1.0in" margin-bottom="0.6in"/>
            <fo:region-before extent="1in"/>
            <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
    </fo:layout-master-set>

<#list receivableInfoList as receivableInfo>
    <#assign fromPartyId = receivableInfo.fromPartyId>
    <#assign fromParty = receivableInfo.fromParty>
    <#assign fromContactInfo = receivableInfo.fromContactInfo>
    <#assign logoImageLocation = receivableInfo.logoImageLocation!>
    <#assign invoiceList = receivableInfo.invoiceList>
    <#assign unpaidTotal = receivableInfo.unpaidTotal>
    <#assign agingSummaryList = receivableInfo.agingSummaryList>

    <fo:page-sequence master-reference="letter-portrait" id="mainSequence">
        <fo:static-content flow-name="xsl-region-before">
            <fo:block font-size="16pt" text-align="center">${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(fromParty.organizationName!"", false))!""}${(fromParty.firstName)!""} ${(fromParty.lastName)!""}</fo:block>
            <fo:block font-size="12pt" text-align="center" margin-bottom="0.1in">Billing Statement</fo:block>
            <#if logoImageLocation?has_content>
                <fo:block-container absolute-position="absolute" top="0in" left="0.25in" width="2in">
                    <fo:block text-align="left">
                        <fo:external-graphic src="${logoImageLocation}" content-height="0.5in" content-width="scale-to-fit" scaling="uniform"/>
                    </fo:block>
                </fo:block-container>
            </#if>
        </fo:static-content>
        <fo:static-content flow-name="xsl-region-after" font-size="8pt">
            <fo:block border-top="thin solid black">
                <fo:block text-align="center">
                    <#if fromContactInfo.postalAddress?has_content>
                    ${(fromContactInfo.postalAddress.address1)!""}<#if fromContactInfo.postalAddress.unitNumber?has_content> #${fromContactInfo.postalAddress.unitNumber}</#if><#if fromContactInfo.postalAddress.address2?has_content>, ${fromContactInfo.postalAddress.address2}</#if>, ${fromContactInfo.postalAddress.city!""}, ${(fromContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${fromContactInfo.postalAddress.postalCode!""}<#if fromContactInfo.postalAddress.postalCodeExt?has_content>-${fromContactInfo.postalAddress.postalCodeExt}</#if><#if fromContactInfo.postalAddress.countryGeoId?has_content>, ${fromContactInfo.postalAddress.countryGeoId}</#if>
                    </#if>
                    <#if fromContactInfo.telecomNumber?has_content>
                        -- <#if fromContactInfo.telecomNumber.countryCode?has_content>${fromContactInfo.telecomNumber.countryCode}-</#if><#if fromContactInfo.telecomNumber.areaCode?has_content>${fromContactInfo.telecomNumber.areaCode}-</#if>${fromContactInfo.telecomNumber.contactNumber!""}
                    </#if>
                    <#if fromContactInfo.emailAddress?has_content> -- ${fromContactInfo.emailAddress}</#if>
                </fo:block>
                <fo:block text-align="center">Statement -- ${ec.l10n.format(asOfTimestamp, dateFormat)} -- Page <fo:page-number/> of <fo:page-number-citation-last ref-id="mainSequence"/></fo:block>
            </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
            <fo:table table-layout="fixed" margin-bottom="0.3in" width="7.5in">
                <fo:table-body><fo:table-row>
                    <fo:table-cell padding="3pt" width="3.25in">
                        <#if toBillingRep?has_content><fo:block>Attention: ${(toBillingRep.organizationName)!""} ${(toBillingRep.firstName)!""} ${(toBillingRep.lastName)!""}</fo:block></#if>
                        <fo:block>${(Static["org.moqui.util.StringUtilities"].encodeForXmlAttribute(toParty.organizationName!"", true))!""} ${(toParty.firstName)!""} ${(toParty.lastName)!""}</fo:block>
                        <#if toContactInfo.postalAddress?has_content>
                            <fo:block font-size="8pt">${(toContactInfo.postalAddress.address1)!""}<#if toContactInfo.postalAddress.unitNumber?has_content> #${toContactInfo.postalAddress.unitNumber}</#if></fo:block>
                            <#if toContactInfo.postalAddress.address2?has_content><fo:block font-size="8pt">${toContactInfo.postalAddress.address2}</fo:block></#if>
                            <fo:block font-size="8pt">${toContactInfo.postalAddress.city!""}, ${(toContactInfo.postalAddressStateGeo.geoCodeAlpha2)!""} ${toContactInfo.postalAddress.postalCode!""}<#if toContactInfo.postalAddress.postalCodeExt?has_content>-${toContactInfo.postalAddress.postalCodeExt}</#if></fo:block>
                            <#if toContactInfo.postalAddress.countryGeoId?has_content><fo:block font-size="8pt">${toContactInfo.postalAddress.countryGeoId}</fo:block></#if>
                        </#if>
                        <#if toContactInfo.telecomNumber?has_content>
                            <fo:block font-size="8pt"><#if toContactInfo.telecomNumber.countryCode?has_content>${toContactInfo.telecomNumber.countryCode}-</#if><#if toContactInfo.telecomNumber.areaCode?has_content>${toContactInfo.telecomNumber.areaCode}-</#if>${toContactInfo.telecomNumber.contactNumber!""}</fo:block>
                        </#if>
                        <#if toContactInfo.emailAddress?has_content>
                            <fo:block font-size="8pt">${toContactInfo.emailAddress}</fo:block>
                        </#if>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt" width="1.5in">
                        <fo:block font-weight="bold">Total Unpaid</fo:block>
                        <fo:block>${ec.l10n.formatCurrency(unpaidTotal, currencyUomId)}</fo:block>
                    </fo:table-cell>
                    <fo:table-cell padding="3pt" width="1.5in">
                        <fo:block font-weight="bold">As of Date</fo:block>
                        <fo:block>${ec.l10n.format(asOfTimestamp, dateFormat)}</fo:block>
                    </fo:table-cell>
                </fo:table-row></fo:table-body>
            </fo:table>

            <#assign invoiceTotalTotal = 0.0>
            <#assign unpaidTotalTotal = 0.0>
            <#if invoiceList?has_content>
            <fo:table table-layout="fixed" width="100%">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">Invoice #</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="left">PO #</fo:block></fo:table-cell>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">Invoice Date</fo:block></fo:table-cell>
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left">Due Date</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="right">Total</fo:block></fo:table-cell>
                    <fo:table-cell width="1.5in" padding="${cellPadding}"><fo:block text-align="right">Unpaid</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list invoiceList as invoice>
                        <#assign invoiceTotalTotal += invoice.invoiceTotal>
                        <#assign unpaidTotalTotal += invoice.unpaidTotal>
                        <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${invoice.invoiceId}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${invoice.referenceNumber!" "}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(invoice.invoiceDate, dateFormat)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${ec.l10n.format(invoice.dueDate, dateFormat)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoice.invoiceTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(invoice.unpaidTotal, invoice.currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </#list>
                    <fo:table-row font-size="${tableFontSize}" border-bottom="thin solid black">
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-weight="bold">Total</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace" font-weight="bold">${ec.l10n.formatCurrency(invoiceTotalTotal, currencyUomId)}</fo:block></fo:table-cell>
                        <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace" font-weight="bold">${ec.l10n.formatCurrency(unpaidTotalTotal, currencyUomId)}</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            </#if>

            <#if agingSummaryList?has_content>
            <fo:table table-layout="fixed" width="100%" margin-top="0.3in">
                <fo:table-header font-size="9pt" font-weight="bold" border-bottom="solid black">
                    <fo:table-cell width="1.0in" padding="${cellPadding}"><fo:block text-align="left"> </fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">Current</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">0 - ${periodDays} days</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${periodDays+1} - ${periodDays*2} days</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">${periodDays*2+1} - ${periodDays*3} days</fo:block></fo:table-cell>
                    <fo:table-cell width="1.3in" padding="${cellPadding}"><fo:block text-align="right">&gt; ${periodDays*3} days</fo:block></fo:table-cell>
                </fo:table-header>
                <fo:table-body>
                    <#list agingSummaryList as summary>
                        <fo:table-row font-size="9pt" border-bottom="thin solid black">
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="left">${summary.description}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.current, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period0, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period1, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period2, currencyUomId)}</fo:block></fo:table-cell>
                            <fo:table-cell padding="${cellPadding}"><fo:block text-align="right" font-family="Courier, monospace">${ec.l10n.formatCurrency(summary.period3 + summary.periodRemaining, currencyUomId)}</fo:block></fo:table-cell>
                        </fo:table-row>
                    </#list>
                </fo:table-body>
            </fo:table>
            </#if>
        </fo:flow>
    </fo:page-sequence>
</#list>
</fo:root>
