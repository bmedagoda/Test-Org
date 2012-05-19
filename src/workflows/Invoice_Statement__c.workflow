<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Final_Approval_Status</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Set Final Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Final_Rejection_Status</fullName>
        <field>Status__c</field>
        <literalValue>Open</literalValue>
        <name>Set Final Rejection Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
