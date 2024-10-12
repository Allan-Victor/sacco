package org.sacco.hr.models;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class JobTitle {
    private Integer jobTitleId;
    private String title;
}
