package org.sacco.hr.dto;

import org.sacco.hr.enums.Gender;
import org.sacco.hr.enums.NatureOfEmployment;
import org.sacco.hr.model.Department;
import org.sacco.hr.model.JobGrade;
import org.sacco.hr.model.JobTitle;

import java.time.LocalDate;

public record StaffResponseDTO(
        String firstName,
        String lastName,
        String nin,
        Gender gender,
        LocalDate dateOfEmployment,
        String phoneNumber,
        String physicalAddress,
        JobTitle jobTitle,
        JobGrade jobGrade,
        NatureOfEmployment natureOfEmployment,
        Department department
) {
}
