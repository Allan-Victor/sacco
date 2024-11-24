package org.sacco.hr.dto;

public record StaffNextOfKinDTO (
        String fullName,
        Integer staffId,
        String relationship,
        String phoneNumber,
        String kinNin,
        String physicalAddress
){}
