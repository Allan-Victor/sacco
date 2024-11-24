package org.sacco.hr.controller;

import lombok.RequiredArgsConstructor;
import org.sacco.hr.dto.StaffDepartmentOrderDTO;
import org.sacco.hr.dto.StaffNextOfKinDTO;
import org.sacco.hr.dto.StaffResponseDTO;
import org.sacco.hr.services.StaffService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/staff")
public class StaffController {

    public final StaffService staffService;

    @GetMapping()
    public ResponseEntity<List<StaffDepartmentOrderDTO>> getStaffListOrderedByDepartment(){
        return ResponseEntity.ok(staffService.fetchStaffListOrderedByDepartment());
    }

    @GetMapping("/departments/{departmentId}/employee-reports")
    public ResponseEntity<List<StaffResponseDTO>> getEmployeeReportsByDepartment(@PathVariable("departmentId") Integer departmentId){
        return ResponseEntity.ok(staffService.fetchStaffDepartmentList(departmentId));
    }

    @GetMapping("/position/{jobTitleId}/employee-reports")
    public ResponseEntity<List<StaffResponseDTO>> getEmployeeReportsByJobTitle(@PathVariable("jobTitleId") Integer jobTitleId){
        return ResponseEntity.ok(staffService.fetchStaffPositionList(jobTitleId));
    }

    @GetMapping
    public ResponseEntity<List<StaffNextOfKinDTO>> getNextOfKinByStaffId(Integer staffId){
        return ResponseEntity.ok(staffService.fetchStaffNextOfKin(staffId));
    }
}
