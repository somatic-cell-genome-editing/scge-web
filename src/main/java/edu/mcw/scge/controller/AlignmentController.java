package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.GuideDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.List;

@Controller
@RequestMapping(value="/data/align")
public class AlignmentController {

    @RequestMapping(value="/protein")
    public String getEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        String cas3 = "MPKPAVESEFSKVLKKHFPGERFRSSYMKRGGKILAAQGEEAVVAYLQGKSEEEPPNFQPPAKCHVVTKSRDFAEWPIM\n" +
                "ASEAIQRYIYALSTTERAACKPGKSSESHAAWFAATGVSNHGYSHVQGLNLIFDHTLGRYDGVLKKVQLRNEKARARLE\n" +
                "INASRADEGLPEIKAEEEEVATNETGHLLQPPGINPSFYVYQTISPQAYRPRDEIVLPPEYAGYVRDPNAPIPLGVVRN\n" +
                "CDIQKGCPGYIPEWQREAGTAISPKTGKAVTVPGLSPKKNKRMRRYWRSEKEKAQDALLVTVRIGTDWVVIDVRGLLRN\n" +
                "RWRTIAPKDISLNALLDLFTGDPVIDVRRNIVTFTYTLDACGTYARKWTLKGKQTKATLDKLTATQTVALVAIDLGQTN\n" +
                "ISAGISRVTQENGALQCEPLDRFTLPDDLLKDISAYRIAWDRNEEELRARSVEALPEAQQAEVRALDGVSKETARTQLC\n" +
                "DFGLDPKRLPWDKMSSNTTFISEALLSNSVSRDQVFFTPAPKKGAKKKAPVEVMRKDRTWARAYKPRLSVEAQKLKNEA\n" +
                "WALKRTSPEYLKLSRRKEELCRRSINYVIEKTRRRTQCQIVIPVIEDLNVRFFHGSGKRLPGWDNFFTAKKENRWFIQG\n" +
                "HKAFSDLRTHRSFYVFEVRPERTSITCPKCGHCEVGNRDGEAFQCLSCGKTCNADLDVATHNLTQVALTGKTMPKREEP\n" +
                "DAQGTAPARKTKKASKSKAPPAEREDQTPAQEPSQTSGSGPKKKRKVEDPKKKRKVSLGSGSDYKDDDDKDYKDDDDK";

        String cas2 = "MPKPAVESEFSKVLKKHFPGERFRSSYMKRGGKILAAQGEEAVVAYLQGKSEEEPPNFQPPAKCHVVTKSRDFAEWPIM\n" +
                "ASEAIQRYIYALSTTERAACKPGKSSESHAAWFAATGVSNHGYSHVQGLNLIFDHTLGRYDGVLKKVQLRNEKARARLE\n" +
                "INASRADEGLPEIKAEEEEVATNETGHLLQPPGINPSFYVYQTISPQAYRPRDEIVLPPEYAGYVRDPNAPIPLGVVRN\n" +
                "CDIQKGCPGYIPEWQREAGTAISPKTGKAVTVPGLSPKKNKRMRRYWRSEKEKAQDALLVTVRIGTDWVVIDVRGLLRN\n" +
                "RWRTIAPKDISLNALLDLFTGDPVIDVRRNIVTFTYTLDACGTYARKWTLKGKQTKATLDKLTATQTVALVAIDLGQTN\n" +
                "ISAGISRVTQENGALQCEPLDRFTLPDDLLKDISAYRIAWDRNEEELRARSVEALPEAQQAEVRALDGVSKETARTQLC\n" +
                "DFGLDPKRLPWDKMSSNTTFISEALLSNSVSRDQVFFTPAPKKGAKKKAPVEVMRKDRTWARAYKPRLSVEAQKLKNEA\n" +
                "WALKRTSPEYLKLSRRKEELCRRSINYVIEKTRRRTQCQIVIPVIEDLNVRFFHGSGKRLPGWDNFFTAKKENRWFIQG\n" +
                "HKAFSDLRTHRSFYVFEVRPERTSITCPKCGHCEVGNRDGEAFQCLSCGKTCNADLDVATHNLTQVALTGKTMPKREEP\n" +
                "DAQGTAPARKTKKASKSKAPPAEREDQTPAQEPSQTSGSGPKKKRKVEDPKKKRKVSLGSGSDYKDDDDKDYKDDDDK";

        String cas1 = "MADTPTLFTQFLRHHLPGQRFRKDILKQAGRILANKGEDATIAFLRGKSEESPPDFQPPVKCPIIACSRPLTEWPIYQA\n" +
                "VAIQGYVYGQSLAEFEASDPGCSKDGLLGWFDKTGVCTDYFSVQGLNLIFQNARKRYIGVQTKVTNRNEKRHKKLKRIN\n" +
                "KRIAEGLPELTSDEPESALDETGHLIDPPGLNTNIYCYQQVSPKPLALSEVNQLPTAYAGYSTSGDDPIQPMVTKDRLS\n" +
                "SKGQPGYIPEHQRALLSQKKHRRMRGYGLKARALLVIVRIQDDWAVIDLRSLLRNAYWRRIVQTKEPSTITKLLKLVTG\n" +
                "PVLDATRMVATFTYKPGIVQVRSAKCLKNKQGSKLFSERYLNETVSVTSIDLGSNNLVAVATYRLVNGNTPELLQRFTL\n" +
                "SHLVKDFERYKQAHDTLEDSIQKTAVASLPQGQQTEIRMWSMYGFREAQERVCQELGLADGSIPWNVMTATSTILTDLF\n" +
                "ARGGDPKKCMFTSEPKKKKNSKQVLYKIRDRAWAKMYRTLLSKETREAWNKALWGLKRGSPDYARLSKRKEELARRCVN\n" +
                "TISTAEKRAQCGRTIVALEDLNIGFFHGRGKQEPGWVGLFTRKKENRWLMQALHKAFLELAHHRGYHVIEVNPAYTSQT\n" +
                "PVCRHCDPDNRDQHNREAFHCIGCGFRGNADLDVATHNIAMVAITGESLKRARGSVASKTPQPLAAEGSGPKKKRKVED\n" +
                "KKKRKVSLGSGSDYKDDDDKDYKDDDDK";


        String root = "/Users/jdepons/clustalOmega";
        //String root = "/data/clustalOmega";

        PrintWriter pw = new PrintWriter(new FileOutputStream(root + "/clustal.fasta"));

        pw.println(">Casϕ-1");
        pw.println(cas1);
        pw.println(">Casϕ-2");
        pw.println(cas2);
        pw.println(">Casϕ-3");
        pw.println(cas3);

        pw.close();

        Process p = Runtime.getRuntime().exec(root + "/clustalo --infile " + root + "/clustal.fasta --threads 8 --MAC-RAM 8000 --outfmt clustal --resno  --output-order tree-order --seqtype protein\n");

        String alignment = "";
        BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line = "";
        while ((line = reader.readLine()) != null) {
            alignment += line + "\n";
        }

        req.setAttribute("alignment",alignment);
        req.setAttribute("action", "Alignment");
        req.setAttribute("page", "/WEB-INF/jsp/tools/align");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
