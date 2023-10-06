package com.keeping.bankservice.api.service.account_history;

import com.keeping.bankservice.api.controller.account_history.response.CountMonthExpenseResponse;
import com.keeping.bankservice.api.controller.account_history.response.ShowAccountHistoryResponse;
import com.keeping.bankservice.api.controller.account_history.response.ShowChildHistoryResponse;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountDetailValidationDto;
import com.keeping.bankservice.api.service.account_history.dto.AddAccountHistoryDto;
import com.keeping.bankservice.api.service.account_history.dto.TransferMoneyDto;
import com.keeping.bankservice.api.service.account_history.dto.TransferToParentDto;
import com.keeping.bankservice.domain.account_history.AccountHistory;
import org.springframework.transaction.annotation.Transactional;

import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;

@Transactional
public interface AccountHistoryService {
    Long addAccountHistory(String memberKey, AddAccountHistoryDto dto) throws URISyntaxException;
    AccountHistory addAccountDetail(String memberKey, AddAccountDetailValidationDto dto);
    Map<String, List<ShowAccountHistoryResponse>> showAccountHistory(String memberKey, String targetKey, String accountNumber);
    Map<String, List<ShowAccountHistoryResponse>> showAccountDailyHistory(String memberKey, String targetKey, String accountNumber, String date, String type);
    Map<String, List<ShowAccountHistoryResponse>> showAccountHistoryRoute(String memberKey, String targetKey, String accountNumber, String date);
    CountMonthExpenseResponse countMonthExpense(String memberKey, String targetKey, String date);
    void transferMoney(String memberKey, TransferMoneyDto dto) throws URISyntaxException;
    void transferToParent(String memberKey, TransferToParentDto dto) throws URISyntaxException;
    List<ShowChildHistoryResponse> showChildHistory();
}
