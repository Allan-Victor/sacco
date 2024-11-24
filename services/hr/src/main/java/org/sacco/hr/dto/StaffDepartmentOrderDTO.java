package org.sacco.hr.dto;

import org.sacco.hr.enums.Gender;
import org.sacco.hr.enums.NatureOfEmployment;
import org.sacco.hr.model.*;

import java.time.LocalDate;
import java.util.List;

public record
StaffDepartmentOrderDTO(
        String firstName,
        String lastName,
        String nin,
        Gender gender,
        String passportPhotoUrl,
        LocalDate dateOfBirth,
        LocalDate dateOfEmployment,
        String phoneNumber,
        String physicalAddress,
        JobTitle jobTitle,
        JobGrade jobGrade,
        NatureOfEmployment natureOfEmployment,
        Department department,
        List<Qualification>qualifications,
        NSSF nssfDetails,
        List<NextOfKin> nextOfKinDetails
) {
}
