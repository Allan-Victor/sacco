package org.sacco.hr.models;

import lombok.Data;
import org.sacco.hr.enums.Gender;
import org.sacco.hr.enums.NatureOfEmployment;

import java.time.LocalDate;
import java.util.List;

@Data
public class Staff {
    private Integer staffId;
    private String firstName;
    private String lastName;
    private String nin;
    private Gender gender;
    private String passportPhotoUrl;
    private LocalDate dateOfBirth;
    private LocalDate dateOfEmployment;
    private String phoneNumber;
    private String physicalAddress;
    private JobTitle jobTitle;
    private JobGrade jobGrade;
    private NatureOfEmployment natureOfEmployment;
    private Department department;
    private List<Qualification> qualifications;
    private NSSF nssfDetails;
    private List<NextOfKin> nextOfKinDetails;



}
