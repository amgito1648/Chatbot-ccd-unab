import { useState, useRef, useEffect } from "react";

const WEBHOOK_URL = "https://unab-n8n.duckdns.org:5678/webhook/71bcaedc-9c88-4af8-9679-2ef8f284d824/chat";

const SESSION_ID = "session_" + Math.random().toString(36).substr(2, 9);

const TypingIndicator = () => (
  <div style={{ display: "flex", alignItems: "center", gap: 6, padding: "12px 16px", background: "rgba(255,255,255,0.06)", borderRadius: "18px 18px 18px 4px", width: "fit-content", marginBottom: 12 }}>
    {[0, 1, 2].map(i => (
      <div key={i} style={{
        width: 8, height: 8, borderRadius: "50%", background: "#00C9A7",
        animation: "bounce 1.2s infinite",
        animationDelay: `${i * 0.2}s`
      }} />
    ))}
  </div>
);

const Message = ({ msg }) => {
  const isUser = msg.role === "user";
  return (
    <div style={{
      display: "flex",
      justifyContent: isUser ? "flex-end" : "flex-start",
      marginBottom: 12,
      animation: "fadeSlideIn 0.3s ease"
    }}>
      {!isUser && (
        <div style={{
          width: 34, height: 34, borderRadius: "50%", background: "linear-gradient(135deg, #00C9A7, #0077FF)",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontSize: 16, marginRight: 10, flexShrink: 0, marginTop: 2,
          boxShadow: "0 0 12px rgba(0,201,167,0.4)"
        }}>🎓</div>
      )}
      <div style={{
        maxWidth: "72%",
        padding: "12px 16px",
        borderRadius: isUser ? "18px 18px 4px 18px" : "18px 18px 18px 4px",
        background: isUser
          ? "linear-gradient(135deg, #0077FF, #00C9A7)"
          : "rgba(255,255,255,0.07)",
        color: "#fff",
        fontSize: 14,
        lineHeight: 1.6,
        boxShadow: isUser
          ? "0 4px 16px rgba(0,119,255,0.3)"
          : "0 2px 8px rgba(0,0,0,0.2)",
        backdropFilter: "blur(10px)",
        border: isUser ? "none" : "1px solid rgba(255,255,255,0.1)",
        whiteSpace: "pre-wrap",
        wordBreak: "break-word"
      }}>
        {msg.content}
      </div>
      {isUser && (
        <div style={{
          width: 34, height: 34, borderRadius: "50%", background: "linear-gradient(135deg, #0077FF, #6C3AFF)",
          display: "flex", alignItems: "center", justifyContent: "center",
          fontSize: 15, marginLeft: 10, flexShrink: 0, marginTop: 2
        }}>👤</div>
      )}
    </div>
  );
};

export default function ChatbotCCD() {
  const [messages, setMessages] = useState([
    { role: "assistant", content: "¡Hola! Bienvenido al asistente virtual del Centro de Competencias Digitales de la UNAB. Para ayudarte de forma personalizada, por favor indícame tu código de estudiante." }
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef(null);
  const inputRef = useRef(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, loading]);

  const sendMessage = async () => {
    const text = input.trim();
    if (!text || loading) return;

    setMessages(prev => [...prev, { role: "user", content: text }]);
    setInput("");
    setLoading(true);

    try {
      const res = await fetch(WEBHOOK_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ chatInput: text, sessionId: SESSION_ID })
      });
      const data = await res.json();
      const reply = data.output || data.text || data.message || data.response || JSON.stringify(data);
      setMessages(prev => [...prev, { role: "assistant", content: reply }]);
    } catch (err) {
      setMessages(prev => [...prev, { role: "assistant", content: "Lo siento, hubo un error de conexión. Por favor intenta de nuevo." }]);
    } finally {
      setLoading(false);
      inputRef.current?.focus();
    }
  };

  const handleKey = (e) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap');
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #080C14; font-family: 'DM Sans', sans-serif; }
        @keyframes bounce {
          0%, 60%, 100% { transform: translateY(0); }
          30% { transform: translateY(-6px); }
        }
        @keyframes fadeSlideIn {
          from { opacity: 0; transform: translateY(10px); }
          to { opacity: 1; transform: translateY(0); }
        }
        @keyframes pulseGlow {
          0%, 100% { box-shadow: 0 0 20px rgba(0,201,167,0.3); }
          50% { box-shadow: 0 0 40px rgba(0,201,167,0.6); }
        }
        @keyframes gradientShift {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
        }
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 2px; }
        textarea:focus { outline: none; }
        textarea { resize: none; }
      `}</style>

      <div style={{
        minHeight: "100vh",
        background: "radial-gradient(ellipse at top left, #0D1F3C 0%, #080C14 50%, #0A1628 100%)",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: 20,
        position: "relative",
        overflow: "hidden"
      }}>

        {/* Background decorative elements */}
        <div style={{
          position: "absolute", top: -100, right: -100,
          width: 400, height: 400, borderRadius: "50%",
          background: "radial-gradient(circle, rgba(0,119,255,0.08) 0%, transparent 70%)",
          pointerEvents: "none"
        }} />
        <div style={{
          position: "absolute", bottom: -100, left: -100,
          width: 500, height: 500, borderRadius: "50%",
          background: "radial-gradient(circle, rgba(0,201,167,0.06) 0%, transparent 70%)",
          pointerEvents: "none"
        }} />

        {/* Header */}
        <div style={{ textAlign: "center", marginBottom: 28, zIndex: 1 }}>
          <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: 12, marginBottom: 8 }}>
            <div style={{
              width: 48, height: 48, borderRadius: 14,
              background: "linear-gradient(135deg, #0077FF, #00C9A7)",
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: 24, animation: "pulseGlow 3s ease infinite",
              boxShadow: "0 0 20px rgba(0,201,167,0.3)"
            }}>🎓</div>
            <div>
              <h1 style={{
                fontFamily: "'Syne', sans-serif",
                fontSize: 22, fontWeight: 800, color: "#fff",
                letterSpacing: "-0.5px"
              }}>Asistente CCD</h1>
              <p style={{ fontSize: 12, color: "rgba(255,255,255,0.4)", letterSpacing: 2, textTransform: "uppercase" }}>
                UNAB · Centro de Competencias Digitales
              </p>
            </div>
          </div>
          <div style={{
            display: "inline-flex", alignItems: "center", gap: 6,
            background: "rgba(0,201,167,0.1)", border: "1px solid rgba(0,201,167,0.2)",
            borderRadius: 20, padding: "4px 12px"
          }}>
            <div style={{ width: 6, height: 6, borderRadius: "50%", background: "#00C9A7", animation: "pulseGlow 2s infinite" }} />
            <span style={{ fontSize: 11, color: "#00C9A7", fontWeight: 500 }}>En línea</span>
          </div>
        </div>

        {/* Chat Container */}
        <div style={{
          width: "100%", maxWidth: 680,
          background: "rgba(255,255,255,0.03)",
          borderRadius: 24,
          border: "1px solid rgba(255,255,255,0.08)",
          backdropFilter: "blur(20px)",
          boxShadow: "0 24px 80px rgba(0,0,0,0.4)",
          display: "flex", flexDirection: "column",
          height: "70vh", maxHeight: 600,
          zIndex: 1, overflow: "hidden"
        }}>

          {/* Messages area */}
          <div style={{
            flex: 1, overflowY: "auto",
            padding: "24px 20px 8px",
            display: "flex", flexDirection: "column"
          }}>
            {messages.map((msg, i) => (
              <Message key={i} msg={msg} />
            ))}
            {loading && (
              <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 12 }}>
                <div style={{
                  width: 34, height: 34, borderRadius: "50%",
                  background: "linear-gradient(135deg, #00C9A7, #0077FF)",
                  display: "flex", alignItems: "center", justifyContent: "center",
                  fontSize: 16, flexShrink: 0
                }}>🎓</div>
                <TypingIndicator />
              </div>
            )}
            <div ref={bottomRef} />
          </div>

          {/* Divider */}
          <div style={{ height: 1, background: "rgba(255,255,255,0.06)", margin: "0 20px" }} />

          {/* Input area */}
          <div style={{ padding: "16px 20px", display: "flex", gap: 12, alignItems: "flex-end" }}>
            <textarea
              ref={inputRef}
              value={input}
              onChange={e => setInput(e.target.value)}
              onKeyDown={handleKey}
              placeholder="Escribe tu mensaje..."
              rows={1}
              style={{
                flex: 1,
                background: "rgba(255,255,255,0.06)",
                border: "1px solid rgba(255,255,255,0.1)",
                borderRadius: 14,
                padding: "12px 16px",
                color: "#fff",
                fontSize: 14,
                fontFamily: "'DM Sans', sans-serif",
                lineHeight: 1.5,
                maxHeight: 120,
                transition: "border-color 0.2s",
              }}
              onFocus={e => e.target.style.borderColor = "rgba(0,201,167,0.5)"}
              onBlur={e => e.target.style.borderColor = "rgba(255,255,255,0.1)"}
            />
            <button
              onClick={sendMessage}
              disabled={loading || !input.trim()}
              style={{
                width: 46, height: 46, borderRadius: 14, border: "none",
                background: loading || !input.trim()
                  ? "rgba(255,255,255,0.06)"
                  : "linear-gradient(135deg, #0077FF, #00C9A7)",
                cursor: loading || !input.trim() ? "not-allowed" : "pointer",
                display: "flex", alignItems: "center", justifyContent: "center",
                fontSize: 18, flexShrink: 0,
                transition: "all 0.2s",
                boxShadow: loading || !input.trim() ? "none" : "0 4px 16px rgba(0,119,255,0.4)",
                transform: loading || !input.trim() ? "scale(1)" : "scale(1)"
              }}
              onMouseEnter={e => { if (!loading && input.trim()) e.target.style.transform = "scale(1.05)" }}
              onMouseLeave={e => e.target.style.transform = "scale(1)"}
            >
              {loading ? "⏳" : "➤"}
            </button>
          </div>
        </div>

        {/* Footer */}
        <p style={{ marginTop: 16, fontSize: 11, color: "rgba(255,255,255,0.2)", zIndex: 1, letterSpacing: 1 }}>
          UNIVERSIDAD AUTÓNOMA DE BUCARAMANGA © 2026
        </p>
      </div>
    </>
  );
}
