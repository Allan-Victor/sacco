package org.sacco.hr.model;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JobTitle {
    private Integer jobTitleId;
    private String title;
}
