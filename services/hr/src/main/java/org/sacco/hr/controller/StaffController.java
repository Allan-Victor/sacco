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
    // 1. Get staff list ordered by department
    @GetMapping()
    public ResponseEntity<List<StaffDepartmentOrderDTO>> getStaffListOrderedByDepartment(){
        return ResponseEntity.ok(staffService.fetchStaffListOrderedByDepartment());
    }


    // 2. Get employee reports by department ID
    @GetMapping("/departments/{departmentId}/employee-reports")
    public ResponseEntity<List<StaffResponseDTO>> getEmployeeReportsByDepartment(@PathVariable("departmentId") Integer departmentId){
        return ResponseEntity.ok(staffService.fetchStaffDepartmentList(departmentId));
    }

    // 3. Get employee reports by job title ID
    @GetMapping("/position/{jobTitleId}/employee-reports")
    public ResponseEntity<List<StaffResponseDTO>> getEmployeeReportsByJobTitle(@PathVariable("jobTitleId") Integer jobTitleId){
        return ResponseEntity.ok(staffService.fetchStaffPositionList(jobTitleId));
    }

    // 4. Get next of kin by staff ID (use query parameter)
    //URL: GET /api/v1/staff/next-of-kin?staffId={staffId}
    @GetMapping("/next-of-kin")
    public ResponseEntity<List<StaffNextOfKinDTO>> getNextOfKinByStaffId(@RequestParam("staffId") Integer staffId){
        return ResponseEntity.ok(staffService.fetchStaffNextOfKin(staffId));
    }
}
